# STORY 1 — $5 off coupon (`SAVE5`)

**As a** customer with a mailer coupon,
**I want** $5 off my order when I use the code `SAVE5`,
**so that** the promotion I received by email translates into a real saving at checkout.

## Description

This is the long-running mailer coupon from marketing. The customer
attaches the code `SAVE5` to the order and five dollars comes off.

There is a minimum spend: the order must be at least $30.00. The minimum
counts the order as it was rung up at full price, before any deals are
applied — Finance measures eligibility on the original ring, not after
discounts. An order that doesn't reach thirty dollars is the support
ticket that never ends (see ticket #4312, a customer who tried it on a
single coffee).

If the code is attached but the order doesn't qualify, checkout is not
blocked and no error is shown — the customer simply pays the normal
price. This is the general rule for coupons: an invalid or ineligible
coupon never crashes anything and never nags the customer; it quietly
does nothing.