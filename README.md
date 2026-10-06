# checkout_engine

A bare-bones checkout engine for a burger restaurant. It can take a
customer's bag, build an order, and compute subtotal, sales tax, and
total.

## Setup

```bash
dart pub get
dart test     # the existing suite should be green
```

## Your task

Read the [`stories/`](stories/) folder, starting with the epic. It
contains everything the product team needs — implement it.

A few ground rules from engineering:

- The menu in `lib/src/catalog.dart` is fixed. Promotions and tests
  depend on those ids and prices; do not edit it.
- The totals logic in `Order` (`subtotalCents`, `taxCents`,
  `totalCents`) is the single source of truth for money math. Finance
  requires every checkout path to compute totals through it — all money
  math must flow through those getters.
- Concrete promotions go in `lib/src/promotions/` and must be
  registered in `lib/src/promotions/registry.dart` — the engine
  discovers them there.
- Money is always integer cents (699 means $6.99).