# Hotel Reservation System — ER diagram

```mermaid
erDiagram
    direction LR
    hotel {
        bigint hotel_id PK
        text name
        text city
    }
    room {
        bigint room_id PK
        bigint hotel_id FK
        text room_number
        numeric nightly_rate
    }
    guest {
        bigint guest_id PK
        text full_name
        text email UK
    }
    reservation {
        bigint reservation_id PK
        bigint guest_id FK
        bigint room_id FK
        date check_in
        date check_out
        text status
        numeric total_amount
    }
    hotel ||--o{ room : "hotel_id"
    guest ||--o{ reservation : "guest_id"
    room ||--o{ reservation : "room_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/Alao_Bolurin_301904150_ERDiagram.png)
