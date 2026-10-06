import '../money.dart';
import '../order.dart';
import 'promotion.dart';
import 'promotion_support.dart';

const _code = 'WELCOME15';
const _discountBps = 1500;

/// STORY 2: 15% off the original subtotal with code WELCOME15, rounded
/// half-up.
class Welcome15Coupon extends Promotion {
  const Welcome15Coupon()
      : super(id: 'welcome15', name: '15% off', requiresCoupon: true);

  @override
  bool isEligible(Order order) =>
      hasCouponCode(order, _code) && order.subtotalCents > 0;

  @override
  Order apply(Order order) => isEligible(order)
      ? order.withDiscount(percentOfCents(order.subtotalCents, _discountBps))
      : order;
}
