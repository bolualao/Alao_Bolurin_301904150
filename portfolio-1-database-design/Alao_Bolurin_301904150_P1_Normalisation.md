# Hotel Reservation System — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| guest_id | reservation records (list) |
| --- | --- |
| 301 | [401] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.status | guest.guest_id | guest.full_name | room.room_id | room.hotel_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | confirmed | 301 | Avery Morgan | 201 | 101 |

Key: reservation_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## reservation_example

| reservation.reservation_id | reservation.guest_id | reservation.room_id | reservation.status | guest.guest_id | guest.full_name | room.room_id | room.hotel_id |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | confirmed | 301 | Avery Morgan | 201 | 101 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## hotel

| hotel_id | name | city |
| --- | --- | --- |
| 101 | Harborlight Hotel | Portland |

## room

| room_id | hotel_id | room_number | nightly_rate |
| --- | --- | --- | --- |
| 201 | 101 | 101 | 145 |

## guest

| guest_id | full_name | email |
| --- | --- | --- |
| 301 | Avery Morgan | avery.morgan@example.test |

## reservation

| reservation_id | guest_id | room_id | check_in | check_out | status | total_amount |
| --- | --- | --- | --- | --- | --- | --- |
| 401 | 301 | 201 | 2026-11-10 | 2026-11-12 | confirmed | 290 |

## Dependencies

- hotel: (hotel_id) → name, city
- room: (room_id) → hotel_id, room_number, nightly_rate
- guest: (guest_id) → full_name, email
- reservation: (reservation_id) → guest_id, room_id, check_in, check_out, status, total_amount

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
