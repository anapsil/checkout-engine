# STORY 3 — Free dessert coupon (`SWEETTOOTH`)

**As a** customer holding a dessert coupon,
**I want** one dessert free with my order when I use the code `SWEETTOOTH`,
**so that** the email campaign's promise is honored at checkout.

## Description

This is the dessert coupon from the email campaign (the customer who
carried his around for three weeks). The code `SWEETTOOTH` makes one
dessert in the bag free.

Desserts range from the $1.79 cookie to the $3.29 sundae, and ops will
not comp the sundae for everyone. The rule ops chose: **the cheapest
dessert in the bag is the free one.** "Cheapest" means the lowest unit
price among the desserts in the bag — per dessert unit, not per line
total. Two cookies — one is free, the other is full price. A cookie and
a sundae — the cookie is free, the sundae is full price. Two cookies and
a sundae — still one cookie free, since one coupon comps exactly one
dessert unit.

If there is no dessert in the bag, the coupon does nothing and checkout
runs normally (same rule as every coupon). One dessert per coupon, which
in practice means one per order, since a customer can attach only one
coupon.