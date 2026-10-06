import '../order.dart';
import 'promotion.dart';

/// A promotion whose discount is attributed to specific product lines and
/// recorded in [Order.lineDiscountCents].
abstract class LineDiscountPromotion extends Promotion {
  const LineDiscountPromotion({
    required super.id,
    required super.name,
    required super.requiresCoupon,
  });

  /// Discount per product id this promotion gives on [order]. Products
  /// that get nothing are left out, so an empty map means not eligible.
  Map<String, int> lineDiscountsFor(Order order);

  @override
  bool isEligible(Order order) => lineDiscountsFor(order).isNotEmpty;

  @override
  Order apply(Order order) => lineDiscountsFor(order).entries.fold(
        order,
        (discounted, entry) =>
            discounted.withDiscount(entry.value, productId: entry.key),
      );
}
