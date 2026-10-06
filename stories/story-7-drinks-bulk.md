# STORY 7 — 10% off 3+ of the same drink (automatic)

**As a** customer buying drinks for a group,
**I want** a volume discount when I buy three or more of the same drink,
**so that** larger orders cost proportionally less per drink.

## Description

The drinks volume play: order three or more of the same drink and ten
percent comes off those drinks. Not the whole order — only the drink
lines that hit the count.

Reference math from the PO: three sodas ring at $5.97 total; ten percent
is $0.597, which rounds to $0.60 off, so the sodas land at $5.37. Four
coffees — ten percent off the coffees only, nothing else in the order is
touched. Different drink types count separately: three of the *same*
drink triggers it, three-of-this plus two-of-that does not. Two of a
drink: no deal. Three: ten percent off those three.

This deal is automatic. If the customer qualifies for this and another
automatic deal at the same time, one applies — whichever gives the better
price, per the epic.

Note the milkshake exclusion from STORY 6 does **not** extend to this
deal; that rule belongs to the trio promotion only.