import 'order.dart';
import 'promotions/promotion.dart';
import 'promotions/registry.dart';

class CheckoutEngine {
  final List<Promotion>? _promotions;

  /// Uses [promotions] when given, otherwise the ones registered in
  /// [availablePromotions].
  const CheckoutEngine({List<Promotion>? promotions})
      : _promotions = promotions;

  List<Promotion> get promotions => _promotions ?? availablePromotions;

  /// Prices every allowed combination of at most one automatic deal and
  /// the order's coupon, and returns the one with the lowest total. It
  /// always starts from the original ring, dropping any discount [order]
  /// already carries, so calculating twice gives the same result. The
  /// automatic deal goes first so coupons see its line discounts. On equal
  /// totals a combination with an automatic deal beats one without, and
  /// otherwise the earliest in [promotions] order wins.
  Order calculate(Order order) {
    final ring = Order(lines: order.lines, couponCode: order.couponCode);
    final automaticDeals = promotions
        .where((promotion) => !promotion.requiresCoupon)
        .where((deal) => deal.isEligible(ring));
    final coupons = promotions.where((promotion) => promotion.requiresCoupon);

    final candidates = [
      for (final deal in [...automaticDeals, null])
        for (final coupon in [null, ...coupons])
          [deal, coupon].nonNulls.fold(
                ring,
                (priced, promotion) => promotion.apply(priced),
              ),
    ];

    return candidates.reduce(
      (best, candidate) =>
          candidate.totalCents < best.totalCents ? candidate : best,
    );
  }
}
