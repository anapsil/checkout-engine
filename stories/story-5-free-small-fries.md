# STORY 5 — Free small fries with any burger (automatic)

**As a** customer ordering a burger,
**I want** a small fries added at no charge,
**so that** the meal feels complete without me having to find a deal first.

## Description

The cross-sell play the growth team has been requesting: buy a burger,
get a small fries free. Automatic like the rest — the order has a burger
in it, and a small fries rings at no charge. Again modeled as a discount:
the small fries ring at $2.49 and the deal takes the $2.49 off.

Ops was explicit on two points. It is **one free fries per order**, not
one per burger — two burgers still means one free small fries. And the
freebie is specifically the **small** fries ($2.49): a large fries in the
bag does not count, and with no small fries in the bag there is no deal.
Any burger qualifies — small, medium or large.

No burger in the bag, no deal: checkout runs completely normal. This is
an automatic promotion; the epic's one-automatic-deal and best-price
rules apply.