# Hotel Reservation System — database design

My case study records hotel, room, guest, reservation.

## Users

- Hotel staff managing rooms and reservations
- Guests making or changing reservations

## Main operations

- Create and look up hotels, rooms, guests, and reservations.
- Join reservations to guests, rooms, and hotels to review booking details.
- Filter reservations by check-in date and summarize bookings by hotel.
- Separate benchmark plan: generate 20000 synthetic reservations, then compare the query plan and measured runtime for the same check-in date range query with and without a B-tree index on reservation.check_in.

## Entities

| Entity | Information stored |
| --- | --- |
| hotel | A lodging property that contains rooms. |
| room | A bookable room belonging to one hotel. |
| guest | A person who may make hotel reservations. |
| reservation | A guest's booking of one room for a date range. |

## hotel

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| hotel_id | BIGINT | PK | Yes |
| name | TEXT |  | Yes |
| city | TEXT |  | Yes |
- Unique key: (name, city).

## room

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| room_id | BIGINT | PK | Yes |
| hotel_id | BIGINT | FK | Yes |
| room_number | TEXT |  | Yes |
| nightly_rate | NUMERIC(18,2) |  | Yes |
- hotel_id → hotel.hotel_id
- Unique key: (hotel_id, room_number).

## guest

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| guest_id | BIGINT | PK | Yes |
| full_name | TEXT |  | Yes |
| email | TEXT | Unique | Yes |
- Unique key: (email).

## reservation

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| reservation_id | BIGINT | PK | Yes |
| guest_id | BIGINT | FK | Yes |
| room_id | BIGINT | FK | Yes |
| check_in | DATE |  | Yes |
| check_out | DATE |  | Yes |
| status | TEXT |  | Yes |
| total_amount | NUMERIC(18,2) |  | Yes |
- guest_id → guest.guest_id
- room_id → room.room_id

## Relationships and business rules

- A hotel name and city pair identifies one hotel.
- Room numbers must be unique within their hotel.
- Every room must reference an existing hotel.
- Each guest email address can appear only once.
- Every reservation must reference an existing guest.
- Every reservation must reference an existing room.
- The check-out date must be later than the check-in date.

## Assumptions

- Each room belongs to exactly one hotel, and each reservation refers to exactly one guest and one room.
- Entity IDs are globally unique single-column primary keys.
- A reservation's check-out date must be later than its check-in date.
- For the worked normalization example, start with reservation(reservation_id, guest_id, room_id, check_in, check_out, status, total_amount). Keep guest details in guest and room details in room, rather than repeating those ancestor attributes in reservation.

