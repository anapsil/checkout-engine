import 'catalog.dart';
import 'product.dart';

/// Thrown when a bag receives a product id that is not on the menu.
class UnknownProductException implements Exception {
  final String productId;

  const UnknownProductException(this.productId);

  @override
  String toString() =>
      'UnknownProductException: "$productId" is not in the catalog';
}

class BagItem {
  final String productId;
  final int quantity;
  final Product product;

  /// Throws [UnknownProductException] when [productId] is not in the
  /// catalog and [ArgumentError] when [quantity] is below one.
  BagItem(this.productId, {this.quantity = 1})
      : product =
            catalog[productId] ?? (throw UnknownProductException(productId)) {
    if (quantity < 1) {
      throw ArgumentError.value(quantity, 'quantity', 'must be at least 1');
    }
  }
}

class Bag {
  final List<BagItem> items;

  Bag([List<BagItem>? items]) : items = items ?? <BagItem>[];

  void add(String productId, {int quantity = 1}) {
    items.add(BagItem(productId, quantity: quantity));
  }
}
