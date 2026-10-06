import 'package:checkout_engine/checkout_engine.dart';
import 'package:test/test.dart';

void main() {
  const engine = CheckoutEngine();

  Order order(Map<String, int> quantities, {String? couponCode}) {
    final bag = Bag();
    quantities.forEach((id, quantity) => bag.add(id, quantity: quantity));
    return Order.fromBag(bag, couponCode: couponCode);
  }

  group('registry', () {
    test('registers all eight promotions with unique ids', () {
      final ids = availablePromotions.map((promotion) => promotion.id);

      expect(ids.toSet(), hasLength(8));
    });

    test('registers four automatic deals and four coupons', () {
      final coupons = availablePromotions.where((p) => p.requiresCoupon);

      expect(coupons, hasLength(4));
    });
  });

  group('CheckoutEngine.calculate applied promotions', () {
    test('lists only the winning automatic deal and what it saved', () {
      final result = engine.calculate(order({'burger-small': 1, 'soda': 3}));

      expect(result.appliedPromotions, [
        const AppliedPromotion(
          id: 'small-burger-499',
          name: r'Small Burger for $4.99',
          discountCents: 200,
        ),
      ]);
    });

    test('lists the deal and then the coupon', () {
      final result = engine.calculate(
        order({'burger-small': 1}, couponCode: 'WELCOME15'),
      );

      expect(
        result.appliedPromotions.map((applied) => applied.id),
        ['small-burger-499', 'welcome15'],
      );
      expect(result.appliedPromotions.last.discountCents, 105);
    });

    test('adds up to the order discount', () {
      final result = engine.calculate(
        order({'burger-small': 2, 'fries-small': 1}, couponCode: 'FOUR99'),
      );

      final saved = result.appliedPromotions
          .fold(0, (sum, applied) => sum + applied.discountCents);
      expect(saved, result.discountCents);
    });

    test('keeps the automatic deal over an equally priced coupon', () {
      final result = engine.calculate(
        order({'burger-small': 1}, couponCode: 'FOUR99'),
      );

      expect(
        result.appliedPromotions.map((applied) => applied.id),
        ['small-burger-499'],
      );
    });

    test('is empty when no promotion applies', () {
      final result = engine.calculate(
        order({'salad': 1}, couponCode: 'BOGUS'),
      );

      expect(result.appliedPromotions, isEmpty);
    });
  });

  group('CheckoutEngine.calculate', () {
    test('matches the Finance reference example of 11.92', () {
      final result = engine.calculate(order({'burger-small': 1, 'soda': 3}));

      expect(result.discountCents, 200);
      expect(result.lineDiscountCents, {'burger-small': 200});
      expect(result.taxCents, 96);
      expect(result.totalCents, 1192);
    });

    test('applies only one automatic deal, the cheapest for the order', () {
      final result = engine.calculate(
        order({'burger-small': 1, 'fries-small': 1, 'soda': 3}),
      );

      expect(result.discountCents, 249);
      expect(result.lineDiscountCents, {'fries-small': 249});
    });

    test('prefers the trio over the volume deal on six sodas', () {
      expect(engine.calculate(order({'soda': 6})).discountCents, 398);
    });

    test('falls back to the volume deal on three milkshakes', () {
      expect(engine.calculate(order({'milkshake': 3})).discountCents, 135);
    });

    test('changes nothing when no promotion applies', () {
      final result = engine.calculate(order({'salad': 1}));

      expect(result.discountCents, 0);
      expect(result.totalCents, 549 + 48);
    });

    test('combines the automatic deal with the coupon', () {
      final result = engine.calculate(
        order({'burger-small': 1, 'cookie': 1}, couponCode: 'SWEETTOOTH'),
      );

      expect(result.lineDiscountCents, {'burger-small': 200, 'cookie': 179});
    });

    test('adds WELCOME15 on the original ring to the small burger deal', () {
      final result = engine.calculate(
        order({'burger-small': 1}, couponCode: 'WELCOME15'),
      );

      expect(result.discountCents, 305);
      expect(result.discountedSubtotalCents, 394);
    });

    test('keeps SAVE5 when the deal takes the order under 30.00', () {
      final result = engine.calculate(
        order(
          {
            'burger-small': 3,
            'milkshake': 1,
            'sparkling-water': 1,
            'sundae': 1
          },
          couponCode: 'SAVE5',
        ),
      );

      expect(result.discountCents, 600 + 500);
    });

    test('ignores SAVE5 below the 30.00 minimum', () {
      final result = engine.calculate(
        order({'coffee': 1}, couponCode: 'SAVE5'),
      );

      expect(result.discountCents, 0);
    });

    test('picks the deal that leaves FOUR99 room to save more', () {
      final result = engine.calculate(
        order({'burger-small': 2, 'fries-small': 1}, couponCode: 'FOUR99'),
      );

      expect(result.discountCents, 249 + 400);
      expect(result.lineDiscountCents, {
        'fries-small': 249,
        'burger-small': 400,
      });
    });

    test('never takes a burger below 4.99 with the deal and FOUR99', () {
      final result = engine.calculate(
        order({'burger-small': 1}, couponCode: 'FOUR99'),
      );

      expect(result.discountedSubtotalCents, 499);
    });

    test('treats an unknown coupon as no coupon', () {
      final withBogus = engine.calculate(
        order({'burger-small': 1, 'soda': 3}, couponCode: 'BOGUS'),
      );

      expect(withBogus.totalCents, 1192);
    });

    test('keeps line prices untouched', () {
      final result = engine.calculate(order({'burger-large': 2, 'soda': 3}));

      expect(result.subtotalCents, 2398 + 597);
    });

    test('uses only the promotions it is given', () {
      const bare = CheckoutEngine(promotions: []);

      expect(bare.calculate(order({'burger-small': 1})).discountCents, 0);
    });

    test('breaks ties by registry order', () {
      const tiedEngine = CheckoutEngine(
        promotions: [_FixedDeal('first'), _FixedDeal('second')],
      );

      final result = tiedEngine.calculate(order({'coffee': 1}));

      expect(result.lineDiscountCents.keys, ['first']);
    });
  });
}

class _FixedDeal extends LineDiscountPromotion {
  const _FixedDeal(String id) : super(id: id, name: id, requiresCoupon: false);

  @override
  Map<String, int> lineDiscountsFor(Order order) => {id: 100};
}
