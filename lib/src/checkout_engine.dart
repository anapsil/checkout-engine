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
  /// automatic deal goes first so coupons see its line discounts. On equal
  /// totals a combination with an automatic deal beats one without, and
  /// otherwise the earliest in [promotions] order wins.
  Order calculate(Order order) {
    final automaticDeals = promotions
        .where((promotion) => !promotion.requiresCoupon)
        .where((deal) => deal.isEligible(order));
    final coupons = promotions.where((promotion) => promotion.requiresCoupon);

    final candidates = [
      for (final deal in [...automaticDeals, null])
        for (final coupon in [null, ...coupons])
          [deal, coupon].nonNulls.fold(order, _applyAndRecord),
    ];

    return candidates.reduce(
      (best, candidate) =>
          candidate.totalCents < best.totalCents ? candidate : best,
    );
  }

  Order _applyAndRecord(Order order, Promotion promotion) {
    final discounted = promotion.apply(order);
    final savedCents = discounted.discountCents - order.discountCents;
    if (savedCents <= 0) return order;
    return discounted.copyWith(
      appliedPromotions: [
        ...discounted.appliedPromotions,
        AppliedPromotion(
          id: promotion.id,
          name: promotion.name,
          discountCents: savedCents,
        ),
      ],
    );
  }
}
