# STORY 8 — Any burger for $4.99 coupon (`FOUR99`)

**As a** customer holding a burger coupon,
**I want** any burger in my order to ring up at $4.99 when I use the code `FOUR99`,
**so that** I can choose any burger size and still pay the advertised price.

## Description

The coupon counterpart to the small-burger promotion (STORY 4), created
for the "burgers from $4.99" campaign. The code `FOUR99` drops any burger
in the bag to $4.99: the small burger takes $2.00 off (from $6.99), the
medium takes $4.50 off (from $9.49), the large takes $7.00 off (from
$11.99).

Because this is a price-point deal, not a straight discount, it cannot
push a burger below $4.99: a burger that already rings at $4.99 or less
gains nothing additional from this coupon. In particular, if a small
burger in the bag is already at $4.99 through the automatic promotion,
attaching `FOUR99` contributes nothing extra for that burger — the
customer never pays less than $4.99 for a burger through these two deals.

Coupons are opt-in, one per order, and combine with the active automatic
promotion per the epic. If there is no burger in the bag, the coupon
does nothing and checkout runs normally.