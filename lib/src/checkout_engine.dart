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
  /// the order's coupon, and returns the one with the lowest total. The
  /// automatic deal goes first so coupons see its line discounts. Ties keep
  /// the earliest combination in [promotions] order.
  Order calculate(Order order) {
    final automaticDeals = promotions
        .where((promotion) => !promotion.requiresCoupon)
        .where((deal) => deal.isEligible(order));
    final coupons = promotions.where((promotion) => promotion.requiresCoupon);

    final candidates = [
      for (final deal in [null, ...automaticDeals])
        for (final coupon in [null, ...coupons])
          [deal, coupon].nonNulls.fold(
                order,
                (priced, promotion) => promotion.apply(priced),
              ),
    ];

    return candidates.reduce(
      (best, candidate) =>
          candidate.totalCents < best.totalCents ? candidate : best,
    );
  }
}
