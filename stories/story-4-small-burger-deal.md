# STORY 4 — Small burger for $4.99 (automatic)

**As a** customer ordering a small burger,
**I want** the small burger to ring up at $4.99 at checkout,
**so that** I get a reliably lower price without needing to know a promotion exists.

## Description

This is the flagship promotion for Promotions Engine v1 and will appear
in outdoor advertising, so it must work flawlessly with no customer
action. The small burger normally rings at $6.99; with this promotion
active it sells at $4.99. This deal is specific to the **small** burger —
the medium ($9.49) and large ($11.99) are not part of it.

Operationally the deal is modeled as a discount: the burger rings at
regular price and the promotion takes the difference off — $2.00 for the
small burger. Whatever the implementation, the total the customer sees
must come out correct.

The promotion is automatic: it applies by itself, whether or not the
customer has attached a coupon. Per the epic, it combines with the
customer's coupon, and when a customer qualifies for this and another
automatic promotion at the same time, the one that produces the best
price wins — one automatic promotion per order.