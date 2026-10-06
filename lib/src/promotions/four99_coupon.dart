import '../order.dart';
import 'line_discount_promotion.dart';
import 'promotion_support.dart';

const _code = 'FOUR99';
const _priceFloorCents = 499;

/// STORY 8: every burger rings at $4.99 with code FOUR99, never going
/// below that floor when another deal already discounted the burger.
class Four99Coupon extends LineDiscountPromotion {
  const Four99Coupon()
      : super(
          id: 'four99',
          name: r'Any Burger for $4.99',
          requiresCoupon: true,
        );

  @override
  Map<String, int> lineDiscountsFor(Order order) {
    if (!hasCouponCode(order, _code)) return const {};
    final topUps = {
      for (final burger in productsInCategory(order, burgersCategory))
        burger.id: _topUpToFloor(order, burger.id, burger.priceCents),
    };
    return Map.fromEntries(topUps.entries.where((topUp) => topUp.value > 0));
  }

  int _topUpToFloor(Order order, String burgerId, int unitPriceCents) {
    final maximumOff =
        order.quantityOf(burgerId) * (unitPriceCents - _priceFloorCents);
    return maximumOff - (order.lineDiscountCents[burgerId] ?? 0);
  }
}
