import 'package:checkout_engine/checkout_engine.dart';
import 'package:test/test.dart';

void main() {
  group('Order.taxCents', () {
    test('is computed on the amount after discounts', () {
      final order = Order.fromBag(
        Bag()
          ..add('burger-small')
          ..add('soda', quantity: 3),
      ).copyWith(discountCents: 200);

      expect(order.taxCents, 96);
    });

    test('rounds half up instead of truncating', () {
      final order = Order.fromBag(Bag()..add('salad', quantity: 2));

      expect(order.taxCents, 96);
    });

    test('is zero when the discount covers the whole subtotal', () {
      final order =
          Order.fromBag(Bag()..add('coffee')).copyWith(discountCents: 500);

      expect(order.taxCents, 0);
    });
  });

  group('Order.totalCents', () {
    test('matches the Finance reference example of 11.92', () {
      final order = Order.fromBag(
        Bag()
          ..add('burger-small')
          ..add('soda', quantity: 3),
      ).copyWith(discountCents: 200);

      expect(order.totalCents, 1192);
    });

    test('never goes below zero', () {
      final order =
          Order.fromBag(Bag()..add('coffee')).copyWith(discountCents: 500);

      expect(order.totalCents, 0);
    });
  });

  group('Order.quantityOf', () {
    test('sums every line of the same product', () {
      final order = Order.fromBag(
        Bag()
          ..add('soda', quantity: 2)
          ..add('coffee')
          ..add('soda'),
      );

      expect(order.quantityOf('soda'), 3);
    });

    test('is zero for a product not in the order', () {
      final order = Order.fromBag(Bag()..add('coffee'));

      expect(order.quantityOf('soda'), 0);
    });
  });

  group('Order.withDiscount', () {
    test('adds to the existing order discount', () {
      final order = Order.fromBag(Bag()..add('burger-large'))
          .copyWith(discountCents: 100);

      expect(order.withDiscount(250).discountCents, 350);
    });

    test('merges line discounts instead of replacing them', () {
      final order = Order.fromBag(
        Bag()
          ..add('burger-small')
          ..add('fries-small'),
      ).withDiscount(200, productId: 'burger-small');

      final discounted = order.withDiscount(249, productId: 'fries-small');

      expect(discounted.lineDiscountCents, {
        'burger-small': 200,
        'fries-small': 249,
      });
    });

    test('accumulates line discounts on the same product', () {
      final order = Order.fromBag(Bag()..add('burger-medium'))
          .withDiscount(100, productId: 'burger-medium')
          .withDiscount(150, productId: 'burger-medium');

      expect(order.lineDiscountCents['burger-medium'], 250);
    });

    test('keeps the coupon code and does not mutate the original', () {
      final order = Order.fromBag(Bag()..add('soda'), couponCode: 'SAVE5');

      final discounted = order.withDiscount(50, productId: 'soda');

      expect(discounted.couponCode, 'SAVE5');
      expect(order.discountCents, 0);
      expect(order.lineDiscountCents, isEmpty);
    });
  });
}
