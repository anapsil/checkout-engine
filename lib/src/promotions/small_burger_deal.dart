import '../order.dart';
import 'line_discount_promotion.dart';

const _smallBurgerId = 'burger-small';
const _dealPriceCents = 499;

/// STORY 4: the small burger rings at $4.99, automatically.
class SmallBurgerDeal extends LineDiscountPromotion {
  const SmallBurgerDeal()
      : super(
          id: 'small-burger-499',
          name: r'Small Burger for $4.99',
          requiresCoupon: false,
        );

  @override
  Map<String, int> lineDiscountsFor(Order order) {
    final quantity = order.quantityOf(_smallBurgerId);
    if (quantity <= 0) return const {};
    final unitPrice = order.lines
        .firstWhere((line) => line.product.id == _smallBurgerId)
        .product
        .priceCents;
    if (unitPrice <= _dealPriceCents) return const {};
    return {_smallBurgerId: quantity * (unitPrice - _dealPriceCents)};
  }
}
