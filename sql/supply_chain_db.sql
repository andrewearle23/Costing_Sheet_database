-- ============================
-- Table: ad_hoc_cost_type
-- ============================
CREATE TABLE ad_hoc_cost_type (
    ad_hoc_id      VARCHAR(10)  NOT NULL,
    description    VARCHAR(100) NOT NULL,
    PRIMARY KEY (ad_hoc_id)
);

-- ============================
-- Table: country
-- ============================
CREATE TABLE country (
    country_code   CHAR(3)      NOT NULL,
    country_name   VARCHAR(100) NOT NULL,
    PRIMARY KEY (country_code)
);

-- ============================
-- Table: city
-- ============================
CREATE TABLE city (
    city_code      VARCHAR(10)  NOT NULL,
    city_name      VARCHAR(100) NOT NULL,
    country_code   CHAR(3)      NOT NULL,
    PRIMARY KEY (city_code),
    FOREIGN KEY (country_code) REFERENCES country(country_code)
);

-- ============================
-- Table: client
-- ============================
CREATE TABLE client (
    client_id        VARCHAR(10)   NOT NULL,
    client_name      VARCHAR(150)  NOT NULL,
    payment_terms    VARCHAR(50),
    current_exposure DECIMAL(15,2),
    credit_limit     DECIMAL(15,2),
    PRIMARY KEY (client_id)
);

-- ============================
-- Table: sales_rep
-- ============================
CREATE TABLE sales_rep (
    sales_rep_id   VARCHAR(10)  NOT NULL,
    sales_rep_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (sales_rep_id)
);

-- ============================
-- Table: inco_term
-- ============================
CREATE TABLE inco_term (
    inco_code VARCHAR(10) NOT NULL,
    name      VARCHAR(100) NOT NULL,
    PRIMARY KEY (inco_code)
);

-- ============================
-- Table: deal_status
-- ============================
CREATE TABLE deal_status (
    status_code  VARCHAR(10) NOT NULL,
    description  VARCHAR(50) NOT NULL,
    PRIMARY KEY (status_code)
);

-- ============================
-- Table: product
-- ============================
CREATE TABLE product (
    product_ref   VARCHAR(10)  NOT NULL,
    product_name  VARCHAR(150) NOT NULL,
    specification VARCHAR(255),
    hs_code       VARCHAR(20),
    PRIMARY KEY (product_ref)
);

-- ============================
-- Table: unit_of_measure
-- ============================
CREATE TABLE unit_of_measure (
    uom_id     VARCHAR(10) NOT NULL,
    name       VARCHAR(50) NOT NULL,
    shorthand  VARCHAR(10) NOT NULL,
    PRIMARY KEY (uom_id)
);

-- ============================
-- Table: packaging
-- ============================
CREATE TABLE packaging (
    pack_id   VARCHAR(10)  NOT NULL,
    pack_type VARCHAR(100) NOT NULL,
    PRIMARY KEY (pack_id)
);

-- ============================
-- Table: stock_item
-- ============================
CREATE TABLE stock_item (
    stock_ref    VARCHAR(20) NOT NULL,
    product_ref  VARCHAR(10) NOT NULL,
    uom_id       VARCHAR(10) NOT NULL,
    pack_id      VARCHAR(10),
    PRIMARY KEY (stock_ref),
    FOREIGN KEY (product_ref) REFERENCES product(product_ref),
    FOREIGN KEY (uom_id)      REFERENCES unit_of_measure(uom_id),
    FOREIGN KEY (pack_id)     REFERENCES packaging(pack_id)
);

-- ============================
-- Table: transport_company
-- ============================
CREATE TABLE transport_company (
    transport_id    VARCHAR(10)  NOT NULL,
    transporter_name VARCHAR(150) NOT NULL,
    PRIMARY KEY (transport_id)
);

-- ============================
-- Table: location
-- ============================
CREATE TABLE location (
    location_id   INT AUTO_INCREMENT NOT NULL,
    location_name VARCHAR(150)       NOT NULL,
    city_code     VARCHAR(10),
    country_code  CHAR(3),
    PRIMARY KEY (location_id),
    FOREIGN KEY (city_code)    REFERENCES city(city_code),
    FOREIGN KEY (country_code) REFERENCES country(country_code)
);

-- ============================
-- Table: deal
-- ============================
CREATE TABLE deal (
    deal_no              VARCHAR(20) NOT NULL,
    sales_rep_id         VARCHAR(10) NOT NULL,
    client_id            VARCHAR(10) NOT NULL,
    product_ref          VARCHAR(10) NOT NULL,
    inco_code            VARCHAR(10) NOT NULL,
    status_code          VARCHAR(10) NOT NULL,
    date_created         DATE NOT NULL,
    quote_due_date       DATE,
    quote_submitted_date DATE,
    date_closed          DATE,
    sales_total          DECIMAL(15,2),
    cost_of_sales        DECIMAL(15,2),
    gross_profit         DECIMAL(15,2),
    finance_cost         DECIMAL(15,2),
    profit_after_fc      DECIMAL(15,2),
    gross_profit_pct     DECIMAL(7,4),
    profit_after_fc_pct  DECIMAL(7,4),
    PRIMARY KEY (deal_no),
    FOREIGN KEY (sales_rep_id) REFERENCES sales_rep(sales_rep_id),
    FOREIGN KEY (client_id)    REFERENCES client(client_id),
    FOREIGN KEY (product_ref)  REFERENCES product(product_ref),
    FOREIGN KEY (inco_code)    REFERENCES inco_term(inco_code),
    FOREIGN KEY (status_code)  REFERENCES deal_status(status_code)
);

-- ============================
-- Table: deal_ad_hoc_cost
-- ============================
CREATE TABLE deal_ad_hoc_cost (
    id         INT AUTO_INCREMENT NOT NULL,
    deal_no    VARCHAR(20) NOT NULL,
    cost_ref   VARCHAR(20) NOT NULL,
    ad_hoc_id  VARCHAR(10) NOT NULL,
    quantity   DECIMAL(15,3) NOT NULL,
    unit_price DECIMAL(15,2) NOT NULL,
    total_cost DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no)   REFERENCES deal(deal_no),
    FOREIGN KEY (ad_hoc_id) REFERENCES ad_hoc_cost_type(ad_hoc_id)
);

-- ============================
-- Table: deal_cash_inflow
-- ============================
CREATE TABLE deal_cash_inflow (
    id            INT AUTO_INCREMENT NOT NULL,
    deal_no       VARCHAR(20) NOT NULL,
    quantity      DECIMAL(15,3) NOT NULL,
    sales_price   DECIMAL(15,2) NOT NULL,
    deposit_pct   DECIMAL(5,4) NOT NULL,
    deposit_date  DATE NOT NULL,
    uplift_start  DATE NOT NULL,
    uplift_days   INT  NOT NULL,
    travel_days   INT  NOT NULL,
    terms_days    INT  NOT NULL,
    balance_pct   DECIMAL(5,4) NOT NULL,
    total_sales   DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no) REFERENCES deal(deal_no)
);

-- ============================
-- Table: deal_cash_outflow
-- ============================
CREATE TABLE deal_cash_outflow (
    id           INT AUTO_INCREMENT NOT NULL,
    deal_no      VARCHAR(20) NOT NULL,
    stock_ref    VARCHAR(20) NOT NULL,
    quantity     DECIMAL(15,3) NOT NULL,
    purchase_price DECIMAL(15,2) NOT NULL,
    deposit_pct    DECIMAL(5,4) NOT NULL,
    deposit_date   DATE NOT NULL,
    balance_pct    DECIMAL(5,4) NOT NULL,
    balance_date   DATE NOT NULL,
    total_cost     DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no)  REFERENCES deal(deal_no),
    FOREIGN KEY (stock_ref) REFERENCES stock_item(stock_ref)
);

-- ============================
-- Table: deal_sales_line
-- ============================
CREATE TABLE deal_sales_line (
    id            INT AUTO_INCREMENT NOT NULL,
    deal_no       VARCHAR(20) NOT NULL,
    line_type     ENUM('Product','Transport','Ad Hoc') NOT NULL,
    product_ref   VARCHAR(10),
    description   VARCHAR(150) NOT NULL,
    uom_id        VARCHAR(10) NOT NULL,
    quantity      DECIMAL(15,3) NOT NULL,
    purchase_price DECIMAL(15,2) NOT NULL,
    sales_price    DECIMAL(15,2) NOT NULL,
    gp_price       DECIMAL(15,2) NOT NULL,
    gp_pct         DECIMAL(7,4) NOT NULL,
    purchase_cost  DECIMAL(15,2) NOT NULL,
    sales_total    DECIMAL(15,2) NOT NULL,
    gp_total       DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no)     REFERENCES deal(deal_no),
    FOREIGN KEY (uom_id)      REFERENCES unit_of_measure(uom_id),
    FOREIGN KEY (product_ref) REFERENCES product(product_ref)
);

-- ============================
-- Table: deal_stock_cost
-- ============================
CREATE TABLE deal_stock_cost (
    id          INT AUTO_INCREMENT NOT NULL,
    deal_no     VARCHAR(20) NOT NULL,
    stock_ref   VARCHAR(20) NOT NULL,
    uom_id      VARCHAR(10) NOT NULL,
    product_ref VARCHAR(10) NOT NULL,
    quantity    DECIMAL(15,3) NOT NULL,
    unit_price  DECIMAL(15,2) NOT NULL,
    total_cost  DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no)     REFERENCES deal(deal_no),
    FOREIGN KEY (stock_ref)   REFERENCES stock_item(stock_ref),
    FOREIGN KEY (uom_id)      REFERENCES unit_of_measure(uom_id),
    FOREIGN KEY (product_ref) REFERENCES product(product_ref)
);

-- ============================
-- Table: deal_transport_cost
-- ============================
CREATE TABLE deal_transport_cost (
    id                   INT AUTO_INCREMENT NOT NULL,
    deal_no              VARCHAR(20) NOT NULL,
    transport_ref        VARCHAR(20) NOT NULL,
    transport_id         VARCHAR(10),
    collection_city_code VARCHAR(10),
    delivery_city_code   VARCHAR(10),
    quantity             DECIMAL(15,3) NOT NULL,
    quantity_per_truck   DECIMAL(15,3),
    unit_price           DECIMAL(15,2) NOT NULL,
    total_cost           DECIMAL(15,2) NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (deal_no)              REFERENCES deal(deal_no),
    FOREIGN KEY (transport_id)         REFERENCES transport_company(transport_id),
    FOREIGN KEY (collection_city_code) REFERENCES city(city_code),
    FOREIGN KEY (delivery_city_code)   REFERENCES city(city_code)
);


