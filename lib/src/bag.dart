import 'catalog.dart';
import 'product.dart';

class BagItem {
  final String productId;
  final int quantity;

  const BagItem(this.productId, {this.quantity = 1});

  Product get product => catalog[productId]!;
}

class Bag {
  final List<BagItem> items;

  Bag([List<BagItem>? items]) : items = items ?? <BagItem>[];

  void add(String productId, {int quantity = 1}) {
    items.add(BagItem(productId, quantity: quantity));
  }
}
