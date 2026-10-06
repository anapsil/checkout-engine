# STORY 2 — 15% off coupon (`WELCOME15`)

**As a** new customer signing up,
**I want** 15% off my entire order with the code `WELCOME15`,
**so that** the signup offer gives me a discount on whatever I choose to order.

## Description

The new-signup coupon. Fifteen percent off the entire order — every line,
the whole subtotal, no category restrictions. Marketing was explicit that
it is "everything, yes even the sodas" (they A/B tested restricted
versions; don't ask).

Finance asked for the exact math to be spelled out so everyone computes
it the same way. Reference example: a single small burger rings at $6.99;
fifteen percent of that is $1.0485, which rounds to $1.05 off, so the
burger comes out at $5.94. That is the number that must appear. The same
fifteen percent applies to any order, rounded per the epic.

To pin down the base amount: the fifteen percent is computed on the order
as rung up at full price, before any automatic deals are applied — the
coupon measures the original ring, the same way Finance measures coupon
minimums (see the epic). With an automatic deal active, the coupon
percent comes off the original subtotal and the two discounts simply add
up on top of the order.

The coupon combines with automatic promotions exactly as the epic
describes.