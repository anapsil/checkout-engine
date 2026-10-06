import 'dart:math';

import 'bag.dart';
import 'money.dart';
import 'product.dart';

class OrderLine {
  final Product product;
  final int quantity;

  const OrderLine(this.product, {required this.quantity});

  int get lineTotalCents => product.priceCents * quantity;

  @override
  String toString() => '${quantity}x ${product.name}';
}

/// All money values are integer cents (699 means $6.99).
///
/// The totals getters below are the single source of truth for money
/// math — every checkout path must compute totals through them.
/// `discountCents` is what drives totals; `lineDiscountCents` is purely
/// informational (how much is already off each line) and does not feed
/// the totals getters.
class Order {
  final List<OrderLine> lines;

  /// Coupon code attached by the customer, if any (e.g. "SAVE5").
  final String? couponCode;

  /// Total discount applied to this order, in cents.
  final int discountCents;

  /// Discount attributed to individual product lines, keyed by product id
  /// (total for the line, all units). Deals that target specific lines —
  /// e.g. a price-point deal on one product — record their discount here
  /// so other line-aware deals can account for what is already off.
  final Map<String, int> lineDiscountCents;

  Order({
    required List<OrderLine> lines,
    this.couponCode,
    this.discountCents = 0,
    Map<String, int>? lineDiscountCents,
  })  : lines = List.unmodifiable(lines),
        lineDiscountCents = Map.unmodifiable(lineDiscountCents ?? const {});

  factory Order.fromBag(Bag bag, {String? couponCode}) {
    final lines = bag.items
        .map((item) => OrderLine(item.product, quantity: item.quantity))
        .toList();
    return Order(lines: lines, couponCode: couponCode);
  }

  int get subtotalCents =>
      lines.fold(0, (sum, line) => sum + line.lineTotalCents);

  /// What the customer pays before tax: the subtotal after every discount,
  /// never below zero.
  int get discountedSubtotalCents => max(0, subtotalCents - discountCents);

  /// The city charges 8.75% sales tax on what the customer actually pays,
  /// rounded half-up.
  int get taxCents {
    const taxRateBps = 875;
    return percentOfCents(discountedSubtotalCents, taxRateBps);
  }

  int get totalCents => discountedSubtotalCents + taxCents;

  /// Units of [productId] across every line of the order.
  int quantityOf(String productId) => lines
      .where((line) => line.product.id == productId)
      .fold(0, (sum, line) => sum + line.quantity);

  /// Adds [cents] to the order discount and, when [productId] is given,
  /// to that product's entry in [lineDiscountCents].
  Order withDiscount(int cents, {String? productId}) {
    final lineDiscounts = {...lineDiscountCents};
    if (productId != null) {
      lineDiscounts.update(
        productId,
        (current) => current + cents,
        ifAbsent: () => cents,
      );
    }
    return copyWith(
      discountCents: discountCents + cents,
      lineDiscountCents: lineDiscounts,
    );
  }

  /// [lineDiscountCents], if given, replaces the whole map.
  Order copyWith({
    String? couponCode,
    int? discountCents,
    Map<String, int>? lineDiscountCents,
  }) {
    return Order(
      lines: lines,
      couponCode: couponCode ?? this.couponCode,
      discountCents: discountCents ?? this.discountCents,
      lineDiscountCents: lineDiscountCents ?? this.lineDiscountCents,
    );
  }

  @override
  String toString() => 'Order(lines: $lines, coupon: $couponCode, '
      'subtotal: $subtotalCents, discount: $discountCents, '
      'tax: $taxCents, total: $totalCents)';
}
