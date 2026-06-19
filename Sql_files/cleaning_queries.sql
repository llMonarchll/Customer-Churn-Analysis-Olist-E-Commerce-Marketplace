-- Cleaning Queries --
-- 1. Checking duplicates --
Select count(*) AS row_count
From olist_customers_dataset_working
Group by customer_id, customer_unique_id, customer_zip_code_prefix, customer_city, customer_state
Having count(*) > 1;

Select customer_id, customer_unique_id, count(*) as row_count
From olist_customers_dataset_working
Group by customer_id, customer_unique_id
Having count(*) > 1;

Select customer_id, count(*) as row_count
From olist_customers_dataset_working
Group by customer_id
Having count(*) > 1;

Select  customer_unique_id, count(*) as row_count
From olist_customers_dataset_working
Group by customer_unique_id
Having count(*) > 1;
-- Since multiple rows are with the same customer_unique_id, need to verify if these are repeated customers or duplicates.

Select c.customer_unique_id, count(o.order_id) as total_orders
From olist_customers_dataset_working c
Join olist_orders_dataset_working o
    On c.customer_id = o.customer_id
Group by c.customer_unique_id
Having count(o.order_id) > 1;

Select *, count(*) as row_count
From olist_geolocation_dataset_working
Group by geolocation_zip_code_prefix, geolocation_lat, geolocation_lng, geolocation_city, geolocation_state
Having count(*) > 1;

Select geolocation_zip_code_prefix, count(*) as row_count, avg(geolocation_lat), avg(geolocation_lng)
From olist_geolocation_dataset_working
Group by geolocation_zip_code_prefix
Having count(*) > 1;

Select order_id, product_id, seller_id, count(*) as row_count
From olist_order_items_dataset_working
Group by order_id, product_id, seller_id
Having count(*) > 1;

Select
    order_id, order_item_id, count(*) as row_count
From olist_order_items_dataset_working
Group by order_id, order_item_id
Having count(*) > 1;

Select *, count(*) as count
From olist_order_payments_dataset_working
Group by order_id, payment_sequential, payment_type, payment_installments, payment_value
Having count(*) > 1 ;

Select count(*) as count
From olist_order_payments_dataset_working
Group by order_id, payment_sequential
Having count(*) > 1 ;

Select review_id, order_id, count(*) as count
From olist_order_reviews_dataset_working
Group by review_id, order_id
Having count(*) > 1 ;

Select review_id, count(*) as count
From olist_order_reviews_dataset_working
group by review_id
Having count(*) > 1 ;

Select order_id, customer_id, count(*) as count
From olist_orders_dataset_working
Group by order_id, customer_id
Having count(*) > 1 ;

Select product_id, count(*) as count
From olist_products_dataset_working
Group by product_id
Having count(*) > 1 ;

Select seller_id, count(*) as count
From olist_sellers_dataset_working
Group by seller_id
Having count(*) > 1 ;

-- Checking Nulls --
Select *
From olist_customers_dataset_working
Where customer_id is null or trim(customer_id) = ''
   or customer_unique_id is null  or trim(customer_unique_id) = ''
   or customer_zip_code_prefix is null  or trim(customer_zip_code_prefix) = ''
   or customer_city is null  or trim(customer_city) = ''
   or customer_state is null  or trim(customer_state) = '';
   
Select *
From olist_geolocation_dataset_working
Where geolocation_zip_code_prefix is null  or trim(geolocation_zip_code_prefix) = ''
   or geolocation_lat is null  or trim(geolocation_lat) = ''
   or geolocation_lng is null  or trim(geolocation_lng) = ''
   or geolocation_city is null  or trim(geolocation_city) = ''
   or geolocation_state is null  or trim(geolocation_state) = '';
   
Select *
From olist_order_items_dataset_working
Where order_id is null  or trim(order_id) = ''
   or order_item_id is null  or trim(order_item_id) = ''
   or product_id is null  or trim(product_id) = ''
   or seller_id is null  or trim(seller_id) = ''
   or shipping_limit_date is null  or trim(shipping_limit_date) = ''
   or price is null  or trim(price) = ''
   or freight_value is null  or trim(freight_value) = '';
   
Select *
From olist_order_payments_dataset_working
Where order_id is null  or trim(order_id) = ''
   or payment_sequential is null  or trim(payment_sequential) = ''
   or payment_type is null  or trim(payment_type) = ''
   or payment_installments is null  or trim(payment_installments) = ''
   or payment_value is null  or trim(payment_value) = '';
   
Select count(*)
From olist_order_payments_dataset_working
Where order_id is null
   or payment_sequential is null;
   
Select *
From olist_order_reviews_dataset_working
Where review_id is null  or trim(review_id) = ''
   or order_id is null  or trim(order_id) = ''
   or review_score is null  or trim(review_score) = ''
   or review_creation_date is null  or trim(review_creation_date) = ''
   or review_answer_timestamp is null  or trim(review_answer_timestamp) = '';
   
Select *
From olist_order_reviews_dataset_working
Where review_id is null  OR trim(review_id) = '';

Select *
From olist_order_reviews_dataset_working
WHERE review_id IS NULL  OR trim(review_id) = ''
   OR order_id IS NULL  OR trim(order_id) = '';

Select *
From olist_orders_dataset_working
Where order_id is null  or trim(order_id) = ''
   or customer_id is null  or trim(customer_id) = ''
   or order_status is null  or trim(order_status) = ''
   or order_purchase_timestamp is null  or trim(order_purchase_timestamp) = ''
   or order_approved_at is null  or trim(order_approved_at) = ''
   or order_delivered_carrier_date is null  or trim(order_delivered_carrier_date) = ''
   or order_delivered_customer_date is null  or trim(order_delivered_customer_date) = ''
   or order_estimated_delivery_date is null  or trim(order_estimated_delivery_date) = '';
 
-- Null counts of olist_orders_dataset_working
Select
    sum(order_id is null or trim(order_id) = '') as order_id_nulls,
    sum(customer_id is null or trim(customer_id) = '') as customer_id_nulls,
    sum(order_status is null or trim(order_status) = '') as status_nulls,
    sum(order_purchase_timestamp is null or trim(order_purchase_timestamp) = '') as purchase_nulls,
    sum(order_approved_at is null  or trim(order_approved_at) = '') as order_approved_nulls,
   sum(order_delivered_carrier_date is null  or trim(order_delivered_carrier_date) = '') as carrier_date_nulls,
   sum( order_delivered_customer_date is null  or trim(order_delivered_customer_date) = '') as delivered_date_nulls,
   sum(order_estimated_delivery_date is null  or trim(order_estimated_delivery_date) = '') as est_delivery_nulls
From olist_orders_dataset_working;

Select order_status, count(order_approved_at) as app_nulls
From olist_orders_dataset_working
Where order_approved_at is null or trim(order_approved_at) = ''
Group by order_status;

Select order_status, count(order_delivered_carrier_date) as carrier_delivered_nulls
From olist_orders_dataset_working
Where order_delivered_carrier_date is null or trim(order_delivered_carrier_date) = ''
Group by order_status;

Select order_status, count(order_delivered_customer_date) as customer_delivered_nulls
From olist_orders_dataset_working
Where order_delivered_customer_date is null or trim(order_delivered_customer_date) = ''
Group by order_status;

Select *
From olist_orders_dataset_working
Where order_status = 'delivered'
  and (
      order_delivered_customer_date is null
      or trim(order_delivered_customer_date) = ''
  );
  
Select *
From olist_orders_dataset_working
Where order_status = 'delivered'
  and (
      order_delivered_carrier_date is null
      or trim(order_delivered_carrier_date) = ''
  );
-- A small number of delivered orders had missing delivery timestamps, likely due to data quality inconsistencies.

Select *
From olist_products_dataset_working
Where product_id is null  or trim(product_id) = ''
   or product_category_name is null  or trim(product_category_name) = ''
   or product_name_lenght is null  or trim(product_name_lenght) = ''
   or product_description_lenght is null  or trim(product_description_lenght) = ''
   or product_photos_qty is null  or trim(product_photos_qty) = ''
   or product_weight_g is null  or trim(product_weight_g) = ''
   or product_length_cm is null  or trim(product_length_cm) = ''
   or product_height_cm is null  or trim(product_height_cm) = ''
   or product_width_cm is null  or trim(product_width_cm) = '';
-- A few rows with category name, name length, description length and photos qty has blank values.

Select count(*) as missing_categories
From olist_products_dataset_working
Where product_category_name is null
   or trim(product_category_name) = '';
   
Select *
From olist_products_dataset_working
Where product_id is null or trim(product_id) = '';
   
Select
    count(*) as missing_categories,
    round(count(*) * 100.0 /
        (Select count(*) From olist_products_dataset_working),2) as pct_missing
From olist_products_dataset_working
Where product_category_name is null
   or trim(product_category_name) = '';
   
Select
    count(*) as products,
    count(distinct product_id) as unique_products
From olist_products_dataset_working
Where product_category_name is null
   or trim(product_category_name) = '';
   
Update olist_products_dataset_working
Set product_category_name = 'unknown'
Where product_category_name is null
   or trim(product_category_name) = '';
-- Identified 609 products (1.85% of records) with missing category information. Missing values were standardized to 'unknown' to preserve product records and ensure consistent category-based analysis.

Select *
From olist_sellers_dataset_working
Where seller_id is null  or trim(seller_id) = ''
   or seller_zip_code_prefix is null  or trim(seller_zip_code_prefix) = ''
   or seller_city is null  or trim(seller_city) = ''
   or seller_state is null  or trim(seller_state) = '';
   
Select *
From product_category_name_translati_working
Where product_category_name_english is null  or trim(product_category_name_english) = ''
   OR product_category_name IS NULL  OR TRIM(product_category_name) = '';

-- Invalid Values

Select avg(price) as avg_price,
max(price) as max_price, 
min(price) as min_price, 
avg(freight_value) as avg_freight, 
max(freight_value) as max_freight, 
min(freight_value) as min_freight
From olist_order_items_dataset_working;

Select *
From olist_order_items_dataset_working
Where price = (Select max(price) From olist_order_items_dataset_working)
   or price = (Select min(price) From olist_order_items_dataset_working)
   or freight_value = (Select max(freight_value) From olist_order_items_dataset_working)
   or freight_value = (Select min(freight_value) From olist_order_items_dataset_working);
   
-- A few orders have 0 amount of freight value, considering this as free shipping.

Select max(payment_installments), min(payment_installments)
From olist_order_payments_dataset_working;

Select * 
From olist_order_payments_dataset_working
Where payment_installments <= 0 ;

Select payment_type, payment_installments, count(*) as cnt
From olist_order_payments_dataset_working
Group by payment_type, payment_installments
Order by payment_type, payment_installments;

Select avg(payment_value) as avg_pay,
max(payment_value) as max_pay, 
min(payment_value) as min_pay
From olist_order_payments_dataset_working;

Select *
From olist_order_payments_dataset_working
Where payment_value = (Select max(payment_value) From olist_order_payments_dataset_working) 
Or payment_value = (Select min(payment_value) From olist_order_payments_dataset_working) ;

Select *
From olist_orders_dataset_working
Where str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') >
	str_to_date(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s') ;
    
Select *
From olist_orders_dataset_working
Where str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') >
	str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s') ;
    
Select *
From olist_orders_dataset_working
Where str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') >
	str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s') ;

Select order_id, order_status, order_purchase_timestamp, order_delivered_carrier_date,
    timestampdiff(hour,
        str_to_date(order_delivered_carrier_date,'%Y-%m-%d %H:%i:%s'),
        str_to_date(order_purchase_timestamp,'%Y-%m-%d %H:%i:%s')
    ) as hours_difference
From olist_orders_dataset_working
Where str_to_date(order_purchase_timestamp,'%Y-%m-%d %H:%i:%s')>
      str_to_date(order_delivered_carrier_date,'%Y-%m-%d %H:%i:%s')
Order by hours_difference desc;
-- Date sequence validation identified 166 records where the carrier delivery timestamp preceded the purchase timestamp. The majority of discrepancies were limited to 0–2 hours and were retained as minor timestamp inconsistencies. Two delivered orders contained significant timestamp anomalies (approximately 4 days and 171 days respectively) within the carrier delivery date field. These records were retained and documented due to insufficient information to determine the correct values.

Select *
From olist_orders_dataset_working
Where order_id = '4021cd7611d6d9ce5ffcd24817fc374f';
-- Date sequence validation identified one delivered order where the carrier delivery timestamp preceded the purchase timestamp by approximately four days. The record was retained and documented as a timestamp anomaly due to insufficient information to determine the correct value.

Select *
From olist_orders_dataset_working
Where order_id = '7c48bb55e8e4f7e56d412e9653db37bc';
-- The carrier timestamp is almost certainly incorrectly recorded. All other order lifecycle dates are internally consistent and indicate a normal completed delivery process.

Select *
From olist_orders_dataset_working
Where str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s')>
      str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s');
      
Select order_id, order_status, order_approved_at, order_delivered_carrier_date,
    timestampdiff(hour,
        str_to_date(order_delivered_carrier_date,'%Y-%m-%d %H:%i:%s'),
        str_to_date(order_approved_at,'%Y-%m-%d %H:%i:%s')
    ) as hours_diff
From olist_orders_dataset_working
Where str_to_date(order_approved_at,'%Y-%m-%d %H:%i:%s')>
      str_to_date(order_delivered_carrier_date,'%Y-%m-%d %H:%i:%s')
Order by hours_diff desc;

Select timestampdiff(hour, 
	str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s'),
	str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s')) as diff_hour, count(*) as total_cnt
From olist_orders_dataset_working
Where str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s')>
	str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')
Group by diff_hour
Order by diff_hour desc;

Select floor(timestampdiff(hour, order_delivered_carrier_dt, order_approved_at_dt) / 24) as diff_days, count(*) as cnt
From olist_orders_dataset_working
Where order_approved_at_dt > order_delivered_carrier_dt
Group by diff_days
Order by cnt desc;
-- Date sequence validation identified 1,359 records where the carrier handoff timestamp preceded the order approval timestamp. Approximately 87% of these discrepancies were limited to 0–1 day and were retained as likely operational or system-recording timing differences. A smaller number of records exhibited larger timing gaps (2–9 days), while one extreme outlier showed a 171-day discrepancy. All records were retained and documented as date-sequence anomalies due to insufficient information to determine correct replacement values.

Select *
From olist_orders_dataset_working
Where str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s')>
      str_to_date(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s');

Select floor(timestampdiff(hour, order_delivered_customer_dt, order_delivered_carrier_dt)) / 24 as diff_day, count(*) as cnt
From olist_orders_dataset_working
Where order_delivered_carrier_dt > order_delivered_customer_dt
Group by diff_day
Order by diff_day desc;
-- Date sequence validation identified 23 delivered orders where the carrier delivery timestamp occurred after the customer delivery timestamp. As these records represented only 0.023% of the dataset and the correct values could not be determined, they were retained and documented as date-sequence anomalies.

Select count(*)
From olist_orders_dataset_working
Where order_estimated_delivery_dt < order_purchase_ts;

Select *
From olist_orders_dataset_working
Where str_to_date(order_delivered_customer_date,'%Y-%m-%d %H:%i:%s') is null;
-- Missing customer delivery dates are largely explained by orders that were not completed or not yet delivered. The null values appear to be business-process related rather than data quality errors.

Select *
From olist_order_payments_dataset_working
Where cast(payment_value as decimal(10,2)) <= 0;

-- Few payment values are 0 as the payment type is voucher and not defined.

Select *
From olist_order_reviews_dataset_working
Where str_to_date(review_creation_date, '%Y-%m_%d %H:%i:%s') > str_to_date(review_answer_timestamp, '%Y-%m-%d %H:%i:%s');

Select *
From olist_products_dataset_working
Where product_width_cm <= 0
or product_height_cm <= 0
or product_length_cm <= 0
or product_weight_g <= 0;
-- One product record containing only a product ID and no descriptive attributes was identified. The record was retained to preserve referential integrity with 17 associated order-item records and documented as a data-quality exception.

Select *
From olist_products_dataset_working
Where product_name_lenght = 0
  and product_description_lenght = 0
  and product_photos_qty = 0
  and product_weight_g = 0
  and product_length_cm = 0
  and product_height_cm = 0
  and product_width_cm = 0;
  
-- Data Standardization

Select distinct(trim(lower(customer_city))) as cleaned_city, 
trim(upper(customer_state)) as cleaned_state
From olist_customers_dataset_working;

Select count(distinct(trim(lower(customer_city)))) as cleaned_city, 
		count(distinct(trim(upper(customer_state)))) as cleaned_state
From olist_customers_dataset_working;

Update olist_customers_dataset_working
Set customer_city = trim(lower(customer_city)),
	customer_state = trim(upper(customer_state));
    
Select customer_city, count(*) as cnt
From olist_customers_dataset_working
Group by customer_city
Order by cnt desc;

Select distinct(trim(lower(geolocation_city))) as cleaned_city, 
trim(upper(geolocation_state)) as cleaned_state
From olist_geolocation_dataset_working;

Select count(distinct(trim(lower(geolocation_city)))) as cleaned_city, 
		count(distinct(trim(upper(geolocation_state)))) as cleaned_state
From olist_geolocation_dataset_working;

Update olist_geolocation_dataset_working
Set geolocation_city = trim(lower(geolocation_city)),
	geolocation_state = trim(upper(geolocation_state));

Select distinct geolocation_state
From olist_geolocation_dataset_working
Order by geolocation_state;

Select geolocation_city, count(*) as cnt
From olist_geolocation_dataset_working
Group by geolocation_city
Order by cnt desc;
-- The customers and the geolocation datset has cities with accentric marks hence only trim and whitespaces standardization applied no advancedd data format has been performed.

Select count(distinct(trim(lower(payment_type))))
From olist_order_payments_dataset_working;

Update olist_order_payments_dataset_working
Set payment_type = trim(lower(payment_type));

Select count(*)
From olist_order_reviews_dataset_working
Where str_to_date(review_creation_date, '%d-%m-%Y %H:%i:%s') is null;

-- The format for dates in 2 columns cannot automatically be converted into datetime, hence adding new columns.
Alter table olist_order_reviews_dataset_working
Add column review_creation_dt datetime,
Add column review_answer_ts datetime ;

Update olist_order_reviews_dataset_working
Set review_creation_dt = str_to_date(review_creation_date, '%d-%m-%Y %H:%i:%s'),
	review_answer_ts = str_to_date(review_answer_timestamp, '%d-%m-%Y %H:%i:%s');

Select * 
From olist_order_reviews_dataset_working 
Where review_creation_dt is null 
	or review_answer_ts is null;

Select count(distinct(order_status))
From olist_orders_dataset_working;

Select distinct(order_status)
From olist_orders_dataset_working;

Select count(distinct(trim(lower(order_status))))
From olist_orders_dataset_working;

-- Orders table has few nulls due to orders are cancelled, unavilable etc, hence conversion has been checked and new columns has been created.

Select count(*)
From olist_orders_dataset_working
Where order_approved_at is not null
  and trim(order_approved_at) <> ''
  and str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s') is null;
  
Select count(*)
From olist_orders_dataset_working
Where order_delivered_carrier_date is not null
  and trim(order_delivered_carrier_date) <> ''
  and str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s') is null;
  
Select count(*)
From olist_orders_dataset_working
Where order_purchase_timestamp is not null
  and trim(order_purchase_timestamp) <> ''
  and str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') is null;

Select count(*)
From olist_orders_dataset_working
Where order_delivered_customer_date is not null
  and trim(order_delivered_customer_date) <> ''
  and str_to_date(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s') is null;

Select count(*)
From olist_orders_dataset_working
Where order_estimated_delivery_date is not null
  and trim(order_estimated_delivery_date) <> ''
  and str_to_date(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s') is null;
  
Alter table olist_orders_dataset_working
add column order_purchase_ts datetime,
add column order_approved_at_dt datetime,
add column order_delivered_carrier_dt datetime,
add column order_delivered_customer_dt datetime,
add column order_estimated_delivery_dt datetime ;

Update olist_orders_dataset_working
Set
    order_purchase_ts = case when trim(order_purchase_timestamp) = '' then null
	else str_to_date(order_purchase_timestamp, '%Y-%m-%d %H:%i:%s') 
        end,
    order_approved_at_dt = case when trim(order_approved_at) = '' then null
	else str_to_date(order_approved_at, '%Y-%m-%d %H:%i:%s') 
		end,
    order_delivered_carrier_dt =case when trim(order_delivered_carrier_date) = '' then null
    else str_to_date(order_delivered_carrier_date, '%Y-%m-%d %H:%i:%s') 
		end,
    order_delivered_customer_dt = case when trim(order_delivered_customer_date) = '' then null
	else str_to_date(order_delivered_customer_date, '%Y-%m-%d %H:%i:%s')
    end,
    order_estimated_delivery_dt = case when trim(order_estimated_delivery_date) = '' then null
    else str_to_date(order_estimated_delivery_date, '%Y-%m-%d %H:%i:%s')
    end;

Select count(distinct(product_category_name))
From olist_products_dataset_working;

Select count(distinct(trim(lower(product_category_name))))
From olist_products_dataset_working;

Select count(distinct(seller_city))
From olist_sellers_dataset_working;

Select seller_city, count(trim(lower(seller_city))) as cnt
From olist_sellers_dataset_working
Group by seller_city
Order by cnt desc;

Select count(distinct(seller_state))
From olist_sellers_dataset_working;

Select count(distinct(trim(lower(seller_state)))) as cnt
From olist_sellers_dataset_working;

Select count(distinct(product_category_name))
From product_category_name_translati_working;

Select count(distinct(trim(lower(product_category_name))))
From product_category_name_translati_working;

Select count(distinct(product_category_name_english))
From product_category_name_translati_working;

Select count(distinct(trim(lower(product_category_name_english))))
From product_category_name_translati_working;

Select distinct o.product_category_name, p.product_category_name
From olist_products_dataset_working o
Left join product_category_name_translati_working p
	On o.product_category_name = p.product_category_name
Where p.product_category_name is null;

-- Category reconciliation identified two valid product categories ('pc_gamer' and 'portateis_cozinha_e_preparadores_de_alimentos') that were present in the Products dataset but absent from the category translation table. These records were retained and documented as missing translation mappings.

-- Referrential integrity check
-- Orders without customers
Select count(*)
From olist_orders_dataset_working o
Left join olist_customers_dataset_working c
	ON o.customer_id = c.customer_id
Where c.customer_id is null;

Create table customer_state_lookup as
Select
    customer_unique_id,
    min(customer_state) as customer_state
From olist_customers_dataset_working
Group by customer_unique_id;
-- Customer state was assigned using the dominant available customer record. Only 39 out of 94,985 customers (<0.05%) had 
-- conflicting state information and were resolved using a deterministic rule.

-- Order items without products
Select *
From olist_order_items_dataset_working oi
Left join olist_products_dataset_working p
	On oi.product_id = p.product_id
Where p.product_id is null;

Select distinct oi.product_id
From olist_order_items_dataset_working oi
Left join olist_products_dataset_working p
    On oi.product_id = p.product_id
Where p.product_id Is null;

-- Payments without orders
Select count(*)
From olist_order_payments_dataset_working p
Left join olist_orders_dataset_working o
	On p.order_id = o.order_id
Where o.order_id is null;

-- Order items without orders
Select count(*)
From olist_order_items_dataset_working oi
Left join olist_orders_dataset_working o
	On oi.order_id = o.order_id
Where o.order_id is null;

-- Order items without sellers
Select count(*)
From olist_order_items_dataset_working oi
Left join olist_sellers_dataset_working s
	On oi.seller_id = s.seller_id
Where s.seller_id is null;

-- Reviews wihtout orders
Select count(*)
From olist_order_reviews_dataset_working r
Left join olist_orders_dataset_working o
	On r.order_id = o.order_id
Where o.order_id is null;

-- Data cleaning, standardization, validation, and referential integrity checks completed. Remaining anomalies were investigated, documented, and retained where no reliable correction method existed.
