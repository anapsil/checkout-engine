# EPIC — Promotions Engine v1

> **Note from engineering:** everything the promotions effort needs is in
> this epic and the stories it links to. Read all of them before writing
> code — rules stated here apply to every story, and details from one
> story often affect the others.

## Background

The growth team has been pushing hard on our competitor's app — the one
that basically sells the deals for you — and the user research backs them
up. Every interview this quarter said some version of the same thing:
customers never know what deals we have, and they don't remember to use
them. One participant had a free-dessert coupon sitting in his email for
three weeks and only remembered at the register, after he'd already paid.
That is the exact moment we lose these customers.

So the direction for v1, part strategy and part pressure from Finance:
deals have to work even when the customer does nothing. If a customer
qualifies for a deal, checkout gives it to them — no hunting, no
remembering, no opt-in. A deal the customer qualifies for should never be
left on the table because they didn't know about it. Coupons are the
exception: marketing keeps them opt-in because they trace redemptions per
campaign.

## System rules (Finance and Ops sign-off)

The following rules were agreed with Finance and apply to every promotion
in this epic. They exist because of the loyalty fiasco last year, when the
app showed people three different totals and support had a meltdown.

**One automatic deal per order.** Deals cannot stack into combo-fests. At
most one automatic promotion is active on an order at any time — ops says
the receipt printer can't fit more than one promo line anyway, and
customers don't read more than one. If a customer qualifies for more than
one automatic deal, the system gives them the one that produces the best
price for that order, and only that one. The customer is never asked to
choose.

**One coupon per order, on top of the automatic deal.** A customer can use
at most one coupon per order (a hard marketing rule). Finance signed off
that the automatic deal and the coupon can be combined on the same order.

**Lowest legal price wins.** The thing Finance actually cares about, in
writing: the customer always ends up paying the lowest price possible out
of all the combinations we are allowed to use. If some combination of one
automatic deal and the coupon is cheaper, that is the combination that
wins. The register must never show a total that isn't the best legal
price.

Finance made us walk through an example in the sign-off meeting, so here
it is in writing. A bag holds one small burger ($6.99) and three sodas
($1.99 each), for a subtotal of $12.96. No coupon attached. Each
automatic deal is priced against this bag: the small-burger deal saves
$2.00; the free-fries deal does not apply (no small fries); the
every-third-drink deal saves $1.99 (three sodas, one free); the
drinks-volume deal saves $0.60 (ten percent of the $5.97 of sodas). The
system may activate exactly one of them, and it activates the
small-burger deal, leaving $10.96 for the customer to pay. Sales tax of
$0.96 is computed on that $10.96 — what the customer actually pays — and
the register shows a total of $11.92. Had any other automatic deal been
picked instead, the total would have been higher, which is exactly what
the lowest-price rule forbids.

**Rounding is half-up, always.** Finance audited the old POS and found we
were losing about forty cents a day to truncation. Every money amount is
rounded half-up to the nearest cent. Finance's reference example: a
discount of $1.0485 becomes $1.05, never $1.04. Tax counts too.

**Tax applies to what the customer actually pays.** Sales tax is
calculated on the amount the customer walks out the door with — after
every discount is said and done — not on the pre-discount price. This is
how it has always worked; it's in writing now so nobody yells at anyone
later.

**Minimums measure the original ring.** If any deal has a minimum spend,
the minimum counts the order as it was rung up, before any discounts. A
discount must not bring an order under a minimum and then have the
minimum retroactively not apply.

## Stories in this epic

- STORY 1 — $5 off coupon (`SAVE5`)
- STORY 2 — 15% off coupon (`WELCOME15`)
- STORY 3 — Free dessert coupon (`SWEETTOOTH`)
- STORY 4 — Small burger for $4.99 (automatic)
- STORY 5 — Free small fries with any burger (automatic)
- STORY 6 — Every third drink is free (automatic)
- STORY 7 — 10% off 3+ of the same drink (automatic)
- STORY 8 — Any burger for $4.99 coupon (`FOUR99`)