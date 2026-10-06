import '../order.dart';
import '../product.dart';

const burgersCategory = 'burgers';
const drinksCategory = 'drinks';
const dessertsCategory = 'desserts';

/// Distinct products in [order], in the order they first appear. Bags may
/// hold the same product on several lines.
List<Product> distinctProducts(Order order) => {
      for (final line in order.lines) line.product.id: line.product,
    }.values.toList();

/// Distinct products of [category] in [order].
List<Product> productsInCategory(Order order, String category) =>
    distinctProducts(order)
        .where((product) => product.category == category)
        .toList();

/// Whether [order] carries the coupon [code], ignoring case and
/// surrounding whitespace.
bool hasCouponCode(Order order, String code) =>
    order.couponCode?.trim().toUpperCase() == code;
