-- Hotel Reservation System: tables, keys and business constraints.
-- Run once in a fresh PostgreSQL database.
BEGIN;
SET LOCAL standard_conforming_strings = on;
CREATE SCHEMA portfolio;
CREATE TABLE portfolio."hotel" (
  "hotel_id" bigint NOT NULL,
  "name" text NOT NULL,
  "city" text NOT NULL,
  CONSTRAINT "pk_hotel" PRIMARY KEY ("hotel_id"),
  CONSTRAINT "uq_hotel_0" UNIQUE ("name", "city")
);
CREATE TABLE portfolio."room" (
  "room_id" bigint NOT NULL,
  "hotel_id" bigint NOT NULL,
  "room_number" text NOT NULL,
  "nightly_rate" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_room" PRIMARY KEY ("room_id"),
  CONSTRAINT "uq_room_0" UNIQUE ("hotel_id", "room_number")
);
CREATE TABLE portfolio."guest" (
  "guest_id" bigint NOT NULL,
  "full_name" text NOT NULL,
  "email" text NOT NULL,
  CONSTRAINT "pk_guest" PRIMARY KEY ("guest_id"),
  CONSTRAINT "uq_guest_0" UNIQUE ("email")
);
CREATE TABLE portfolio."reservation" (
  "reservation_id" bigint NOT NULL,
  "guest_id" bigint NOT NULL,
  "room_id" bigint NOT NULL,
  "check_in" date NOT NULL,
  "check_out" date NOT NULL,
  "status" text NOT NULL,
  "total_amount" numeric(18,2) NOT NULL,
  CONSTRAINT "pk_reservation" PRIMARY KEY ("reservation_id")
);
ALTER TABLE portfolio."room" ADD CONSTRAINT "fk_room_0" FOREIGN KEY ("hotel_id") REFERENCES portfolio."hotel" ("hotel_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_0" FOREIGN KEY ("guest_id") REFERENCES portfolio."guest" ("guest_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "fk_reservation_1" FOREIGN KEY ("room_id") REFERENCES portfolio."room" ("room_id");
ALTER TABLE portfolio."reservation" ADD CONSTRAINT "reservation_dates_valid" CHECK ("check_out" > "check_in");
COMMIT;
