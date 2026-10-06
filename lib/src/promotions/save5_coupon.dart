import '../order.dart';
import 'promotion.dart';
import 'promotion_support.dart';

const _code = 'SAVE5';
const _minimumSubtotalCents = 3000;
const _discountCents = 500;

/// STORY 1: $5 off with code SAVE5 on orders of at least $30, measured on
/// the original ring.
class Save5Coupon extends Promotion {
  const Save5Coupon()
      : super(id: 'save5', name: r'$5 off', requiresCoupon: true);

  @override
  bool isEligible(Order order) =>
      hasCouponCode(order, _code) &&
      order.subtotalCents >= _minimumSubtotalCents;

  @override
  Order apply(Order order) =>
      isEligible(order) ? order.withDiscount(_discountCents) : order;
}
