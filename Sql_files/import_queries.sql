-- Import Queries --
CREATE TABLE olist_geolocation_dataset_working (
    geolocation_zip_code_prefix INT,
    geolocation_lat DECIMAL(10,8),
    geolocation_lng DECIMAL(11,8),
    geolocation_city VARCHAR(100),
    geolocation_state VARCHAR(2)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_geolocation_dataset.csv'
INTO TABLE olist_geolocation_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_customers_dataset_working (
    customer_id varchar(50),
    customer_unique_id varchar(50),
    customer_zip_code_prefix int,
    customer_city VARCHAR(50),
    customer_state varchar(5)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_customers_dataset.csv'
INTO TABLE olist_customers_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_order_items_dataset_working (
    order_id varchar(50),
    order_item_id int,
    product_id varchar(50),
    seller_id VARCHAR(50),
	shipping_limit_date datetime,
    price decimal(10,2),
    freight_value decimal(10,2)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_order_items_dataset.csv'
INTO TABLE olist_order_items_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_order_payments_dataset_working (
    order_id varchar(50),
    payment_sequential int,
    payment_type varchar(25),
    payment_installments int,
    payment_value decimal(10,2)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_order_payments_dataset.csv'
INTO TABLE olist_order_payments_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_order_reviews_dataset_working (
    review_id varchar(50),
    order_id varchar(50),
    review_score int,
    review_creation_date varchar(25),
    review_answer_timestamp varchar(25)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_order_reviewss_dataset.csv'
INTO TABLE olist_order_reviews_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_orders_dataset_working (
	order_id varchar(50),
	customer_id	varchar(50),
	order_status varchar(20),
	order_purchase_timestamp varchar(100),
	order_approved_at varchar(100),
	order_delivered_carrier_date varchar(100),
	order_delivered_customer_date varchar(100),
	order_estimated_delivery_date varchar(100)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_order_reviews_dataset.csv'
INTO TABLE olist_orders_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_products_dataset_working (
	product_id varchar(50),
	product_category_name varchar(50),
	product_name_lenght int,
	product_description_lenght int,
	product_photos_qty int,
	product_weight_g int,
	product_length_cm int,
	product_height_cm int,
	product_width_cm int
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_products_dataset.csv'
INTO TABLE olist_products_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE olist_sellers_dataset_working (
	seller_id varchar(50),
	seller_zip_code_prefix int,
	seller_city varchar(30),
	seller_state varchar(5)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/olist_sellers_dataset.csv'
INTO TABLE olist_sellers_dataset_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

CREATE TABLE product_category_name_translati_working (
	product_category_name varchar(50),
	product_category_name_english varchar(50)
);

LOAD DATA LOCAL INFILE 'C:/mysql_import/product_category_name_translati.csv'
INTO TABLE product_category_name_translati_working
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Primary keys and Indexing

ALTER TABLE olist_customers_dataset_working
ADD PRIMARY KEY (customer_id);

describe olist_customers_dataset_working;

ALTER TABLE olist_orders_dataset_working
ADD PRIMARY KEY (order_id);

CREATE INDEX idx_orders_customer_id
ON olist_orders_dataset_working(customer_id);

SHOW INDEX FROM olist_orders_dataset_working ;

ALTER TABLE olist_order_items_dataset_working
ADD PRIMARY KEY (order_id, order_item_id);

CREATE INDEX idx_order_items_product_id
ON olist_order_items_dataset_working(product_id) ;

CREATE INDEX idx_order_items_seller_id
ON olist_order_items_dataset_working(seller_id);

SHOW INDEX FROM olist_order_items_dataset_working ;

ALTER TABLE olist_order_payments_dataset_working
ADD PRIMARY KEY (order_id, payment_sequential);

SHOW INDEX FROM olist_order_payments_dataset_working ;

ALTER TABLE olist_order_reviews_dataset_working
ADD PRIMARY KEY (review_id, order_id);

SHOW INDEX FROM olist_order_reviews_dataset_working ;

ALTER TABLE olist_products_dataset_working
ADD PRIMARY KEY (product_id);

CREATE INDEX idx_products_product_category_name
ON olist_products_dataset_working(product_category_name) ;

SHOW INDEX FROM olist_products_dataset_working ;

ALTER TABLE olist_sellers_dataset_working
ADD PRIMARY KEY (seller_id);

SHOW INDEX FROM olist_sellers_dataset_working ;

CREATE INDEX idx_product_category_translate_category_name
ON product_category_name_translati_working(product_category_name) ;

SHOW INDEX FROM product_category_name_translati_working ;
