

-- ============================================================
-- QAZAQ DUKENI - Kazakhstani E-Commerce Database
-- PostgreSQL port | 3NF | Rerunnable
-- ============================================================
DROP SCHEMA IF EXISTS qazaq_dukeni CASCADE;
CREATE SCHEMA qazaq_dukeni;

SET search_path TO qazaq_dukeni;

-- ============================================================
-- TABLE: categories
-- ============================================================
CREATE TABLE categories (
    category_id     SERIAL          NOT NULL,
    category_name   VARCHAR(100)    NOT NULL,
    category_desc   TEXT            NOT NULL,
    status          VARCHAR(20)     NOT NULL DEFAULT 'Active',

    PRIMARY KEY (category_id),
    UNIQUE (category_name),

    CONSTRAINT chk_category_status CHECK (status IN ('Active', 'Inactive'))
);

COMMENT ON TABLE categories IS 'Product categories for Qazaq Dukeni';

-- ============================================================
-- TABLE: suppliers
-- ============================================================
CREATE TABLE suppliers (
    supplier_id     SERIAL          NOT NULL,
    supplier_name   TEXT            NOT NULL,
    rating          DECIMAL(2,1)    NOT NULL DEFAULT 0.0,
    date_joined     DATE            NOT NULL,
    phone_number    VARCHAR(15)     NOT NULL,

    PRIMARY KEY (supplier_id),

    CONSTRAINT chk_supplier_rating_min  CHECK (rating >= 0.0),
    CONSTRAINT chk_supplier_rating_max  CHECK (rating <= 5.0),
    CONSTRAINT chk_supplier_date_joined CHECK (date_joined > '2026-01-01')
);

COMMENT ON TABLE suppliers IS 'Registered product suppliers';

-- ============================================================
-- TABLE: products
-- ============================================================
CREATE TABLE products (
    product_id      SERIAL          NOT NULL,
    product_name    TEXT            NOT NULL,
    supplier_id     INT             NOT NULL,
    category_id     INT             NOT NULL,
    sale_count      INT             NOT NULL DEFAULT 0,
    price           DECIMAL(9,2)    NOT NULL,
    product_rating  DECIMAL(2,1)    NOT NULL DEFAULT 0.0,
    stock           INT             NOT NULL DEFAULT 0,

    PRIMARY KEY (product_id),
    CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_product_category FOREIGN KEY (category_id) REFERENCES categories(category_id),

    CONSTRAINT chk_product_price        CHECK (price          >= 0.00),
    CONSTRAINT chk_product_stock        CHECK (stock          >= 0),
    CONSTRAINT chk_product_sale_count   CHECK (sale_count     >= 0),
    CONSTRAINT chk_product_rating_min   CHECK (product_rating >= 0.0),
    CONSTRAINT chk_product_rating_max   CHECK (product_rating <= 5.0)
);

COMMENT ON TABLE products IS 'Product catalogue';

-- ============================================================
-- TABLE: pickup_points
-- ============================================================
CREATE TABLE pickup_points (
    point_id        SERIAL          NOT NULL,
    point_address   VARCHAR(255)    NOT NULL,
    point_number    VARCHAR(15)     NOT NULL,

    PRIMARY KEY (point_id)
);

COMMENT ON TABLE pickup_points IS 'Physical order pickup locations';

-- ============================================================
-- TABLE: customers
-- ============================================================
CREATE TABLE customers (
    customer_id     SERIAL          NOT NULL,
    first_name      VARCHAR(255)    NOT NULL,
    last_name       VARCHAR(255)    NOT NULL,
    address         VARCHAR(255)    NOT NULL,
    date_of_birth   DATE            NOT NULL,
    date_joined     DATE            NOT NULL,
    phone_number    VARCHAR(15)     NOT NULL,
    city            VARCHAR(100)    NOT NULL DEFAULT 'Almaty',

    PRIMARY KEY (customer_id),

    CONSTRAINT chk_customer_date_joined CHECK (date_joined   > '2026-01-01'),
    CONSTRAINT chk_customer_dob_order   CHECK (date_of_birth < date_joined)
);

COMMENT ON TABLE customers IS 'Registered customers';

-- ============================================================
-- TABLE: support_staff
-- ============================================================
CREATE TABLE support_staff (
    staff_id        SERIAL          NOT NULL,
    first_name      VARCHAR(255)    NOT NULL,
    last_name       VARCHAR(255)    NOT NULL,
    date_of_join    DATE            NOT NULL,
    position        VARCHAR(255)    NOT NULL,
    salary          DECIMAL(9,2)    NOT NULL,
    phone_number    VARCHAR(15)     NOT NULL,

    PRIMARY KEY (staff_id),

    CONSTRAINT chk_staff_salary     CHECK (salary       >= 0.00),
    CONSTRAINT chk_staff_date_join  CHECK (date_of_join  > '2026-01-01')
);

COMMENT ON TABLE support_staff IS 'Customer support staff';

-- ============================================================
-- TABLE: payments
-- Created before orders; order_id FK added via ALTER after orders exists
-- NOTE: MySQL SET type has no PostgreSQL equivalent.
--       Replaced with TEXT + CHECK = ANY(ARRAY[...]) to allow
--       a single payment type per record (mirrors typical usage).
--       If multi-type combinations are needed, consider TEXT[] instead.
-- ============================================================
CREATE TABLE payments (
    payment_id      SERIAL          NOT NULL,
    -- SET('Card','Cash','Online','QR') replaced: PostgreSQL has no SET type
    payment_type    TEXT            NOT NULL,
    bonus_added     DOUBLE PRECISION NOT NULL DEFAULT 0,
    payment_time    TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,

    PRIMARY KEY (payment_id),

    CONSTRAINT chk_payment_type  CHECK (payment_type = ANY(ARRAY['Card', 'Cash', 'Online', 'QR'])),
    CONSTRAINT chk_payment_bonus CHECK (bonus_added >= 0)
);

COMMENT ON TABLE payments IS 'Payment records';

-- ============================================================
-- TABLE: orders
-- ============================================================
CREATE TABLE orders (
    order_id        SERIAL          NOT NULL,
    order_date      DATE            NOT NULL,
    customer_id     INT             NOT NULL,
    supplier_id     INT             NOT NULL,
    product_id      INT             NOT NULL,
    payment_id      INT             NOT NULL,
    point_id        INT             NOT NULL,
    send_date       DATE            NOT NULL,
    est_arrival     DATE            NOT NULL,
    status          VARCHAR(30)     NOT NULL DEFAULT 'On the way',

    -- GENERATED STORED: PostgreSQL does not support VIRTUAL generated columns
    -- DATEDIFF(a, b) replaced: PostgreSQL uses native date subtraction (returns INTEGER)
    delivery_days   INT GENERATED ALWAYS AS (est_arrival - send_date) STORED,

    PRIMARY KEY (order_id),
    CONSTRAINT fk_order_customer  FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_order_supplier  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id),
    CONSTRAINT fk_order_product   FOREIGN KEY (product_id)  REFERENCES products(product_id),
    CONSTRAINT fk_order_payment   FOREIGN KEY (payment_id)  REFERENCES payments(payment_id),
    CONSTRAINT fk_order_point     FOREIGN KEY (point_id)    REFERENCES pickup_points(point_id),

    CONSTRAINT chk_order_date   CHECK (order_date > '2026-01-01'),
    CONSTRAINT chk_order_status CHECK (status IN ('On the way', 'Delivered', 'Cancelled', 'Returned'))
);

COMMENT ON TABLE orders IS 'Customer orders';

-- Resolve circular dependency: add order_id FK to payments after orders exists
ALTER TABLE payments
    ADD COLUMN order_id INT NOT NULL,
    ADD CONSTRAINT fk_payment_order FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- ============================================================
-- TABLE: product_reviews
-- ============================================================
CREATE TABLE product_reviews (
    customer_id     INT             NOT NULL,
    product_id      INT             NOT NULL,
    review_text     TEXT            NOT NULL,
    review_rating   DECIMAL(2,1)    NOT NULL,

    PRIMARY KEY (customer_id, product_id),
    CONSTRAINT fk_review_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT fk_review_product  FOREIGN KEY (product_id)  REFERENCES products(product_id),

    CONSTRAINT chk_review_rating_min CHECK (review_rating >= 0.0),
    CONSTRAINT chk_review_rating_max CHECK (review_rating <= 5.0)
);

COMMENT ON TABLE product_reviews IS 'Customer product reviews';

-- ============================================================
-- TABLE: support_tickets
-- ============================================================
CREATE TABLE support_tickets (
    ticket_id       SERIAL          NOT NULL,
    order_id        INT             NOT NULL,
    payment_id      INT             NOT NULL,
    staff_id        INT             NOT NULL,
    status          VARCHAR(30)     NOT NULL DEFAULT 'Not resolved',

    PRIMARY KEY (ticket_id),
    CONSTRAINT fk_ticket_order   FOREIGN KEY (order_id)   REFERENCES orders(order_id),
    CONSTRAINT fk_ticket_payment FOREIGN KEY (payment_id) REFERENCES payments(payment_id),
    CONSTRAINT fk_ticket_staff   FOREIGN KEY (staff_id)   REFERENCES support_staff(staff_id),

    CONSTRAINT chk_ticket_status CHECK (status IN ('Not resolved', 'In progress', 'Resolved', 'Closed'))
);

COMMENT ON TABLE support_tickets IS 'Customer support tickets';

-- ============================================================
-- POSTGRESQL MIGRATION NOTES:
--   AUTO_INCREMENT       → SERIAL
--   LONGTEXT / MEDIUMTEXT→ TEXT (unbounded in PostgreSQL)
--   SET(...)             → TEXT + CHECK = ANY(ARRAY[...])
--   DOUBLE               → DOUBLE PRECISION
--   GENERATED ... VIRTUAL→ GENERATED ... STORED (PG only supports STORED)
--   DATEDIFF(a, b)       → (a - b)  [date subtraction returns INTEGER]
--   COMMENT = '...'      → COMMENT ON TABLE ... IS '...'
--   DROP SCHEMA CASCADE  → drops all dependent objects cleanly
--   USE schema           → SET search_path TO schema
--   CHARACTER SET/COLLATE→ removed (set at DB level in PostgreSQL)
-- ============================================================