-- =====================================================
-- Exploratory Data Analysis
-- =====================================================

Select count(distinct(customer_unique_id)) as total_customers
From olist_customers_dataset_working; -- Total customers

Select count(*) as total_orders
From olist_orders_dataset_working; -- Total orders

Select Round(sum(payment_value),2) as total_revenue
From olist_order_payments_dataset_working; -- Gross total revenue

Select Round(sum(payment_value),2) as realized_revenue
From olist_order_payments_dataset_working Op
Join olist_orders_dataset_working O
	On Op.order_id = O.order_id
Where order_status = 'delivered'; -- Actual total revenue

Select Round(sum(payment_value)/count(distinct(order_id)),2) as gross_avg_order_value
From olist_order_payments_dataset_working; -- Gross average order value

Select Round(sum(payment_value)/count(distinct(Op.order_id)),2) as realized_avg_order_value
From olist_order_payments_dataset_working Op
Join olist_orders_dataset_working O
	On Op.order_id = O.order_id
Where order_status = 'delivered'; -- Actual average order value

Select Round(sum(price)/count(distinct(order_id)),2) as avg_merchendise_value
From olist_order_items_dataset_working; -- Gross average merchendise value

Select Round(sum(price)/ count(distinct(Op.order_id)),2) as realized_avg_merchendise_value
From olist_order_items_dataset_working Op
Join olist_orders_dataset_working O
	On Op.order_id = O.order_id
Where order_status = 'delivered'; -- Actual average merchendise value

Select order_status, count(*) as total_orders
From olist_orders_dataset_working
Group by order_status
Order by total_orders desc; -- Orders count by order status

Select order_status, count(*) as total_orders, round(count(*) * 100 / (select count(*) from olist_orders_dataset_working), 2) as order_percentage
From olist_orders_dataset_working
Group by order_status
Order by total_orders desc; -- Orders percentage by order status

Select Year(order_purchase_ts) as yr, Month(order_purchase_ts) as mn, round(sum(payment_value), 2) as revenue
From olist_orders_dataset_working O
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where order_status = 'delivered'
Group by yr, mn
Order by yr, mn desc; -- Revenue by month and year

Select yr, mn, revenue, previous_month_revenue, round(((revenue - previous_month_revenue) *1.0) / revenue, 2) as revenue_percentage
From (Select yr, mn, revenue, lag(revenue) over(order by yr, mn) as previous_month_revenue
From (Select Year(order_purchase_ts) as yr, Month(order_purchase_ts) as mn, round(sum(payment_value), 2) as revenue
From olist_orders_dataset_working O
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where order_status = 'delivered'
Group by yr, mn
Order by yr, mn ) as monthly_revenue) as Revenue_trend ; -- Revenue trend over the months

Select customer_state, count(*) as customers
From olist_customers_dataset_working
Group by customer_state
Order by customers desc ; -- Total customers by state

Select C.customer_state, count(C.customer_id) as customers, round(sum(payment_value), 2) as revenue
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Join olist_order_payments_dataset_working Op
	 On O.order_id = Op.order_id
Where order_status = 'delivered'
Group by customer_state
Order by customers desc ; -- Revenue and customer count by states

Select yr, mn, orders_count, previous_month_orders, round(((orders_count - previous_month_orders) *1.0) / orders_count, 2) as order_count_percentage
From (Select yr, mn, orders_count, lag(orders_count) over(order by yr, mn) as previous_month_orders
From (Select Year(order_purchase_ts) as yr, Month(order_purchase_ts) as mn, count(*) as orders_count
From olist_orders_dataset_working 
Where order_status = 'delivered'
Group by yr, mn
Order by yr, mn ) as monthly_orders) as Order_trend ; -- Order trend over the months

Select payment_type,
		count(*) as transactions
From olist_order_payments_dataset_working
Group by payment_type
Order by transactions desc ; -- transactions count by payment type 

Select payment_installments,
		round(avg(payment_value), 2) as avg_payment_value
From olist_order_payments_dataset_working
Group by payment_installments
Order by avg_intsallment_value desc ; -- Average payment value by installment count

Select round(avg(review_score), 2) as avg_review_score
From olist_order_reviews_dataset_working ; -- Average review score

Select round( 100 * sum( case
					when order_delivered_customer_dt > order_estimated_delivery_dt
                    then 1
                    else 0
                    end) / count(*), 2) as late_delivery_rate
From olist_orders_dataset_working
Where order_status = 'delivered' ; -- Late delivery rate

Select count(*) as repeat_customers
From (Select C.customer_unique_id
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = o.customer_id
Group by C.customer_unique_id
Having count(*) > 1) as Customers ; -- Total repeat customers

With category_revenue as 
(	Select Po.category_english, 
			round(sum(Oi.price), 2) as revenue
	From (Select Pc.product_category_name_english as category_english, P.product_id as Product_id
			From olist_products_dataset_working P
			Join product_category_name_translati_working Pc
				On P.product_category_name = Pc.product_category_name ) as Po
	Join olist_order_items_dataset_working Oi
		On Po.product_id = Oi.product_id
	Join (Select order_id 
			From olist_orders_dataset_working 
			Where order_status = 'delivered') O
		On Oi.order_id = O.order_id
	Group by Po.category_english)
Select category_english,
		revenue,
        round( revenue * 100 /
				sum(revenue) over(), 2) as category_revenue_pct
From category_revenue
Order by revenue desc
Limit 10 ; -- Top 10 categories by revenue

Select Po.category_english, count(distinct(Oi.order_id)) as Total_orders
From (Select Pc.product_category_name_english as category_english, P.product_id as Product_id
From olist_products_dataset_working P
Join product_category_name_translati_working Pc
	On P.product_category_name = Pc.product_category_name ) as Po
Join olist_order_items_dataset_working Oi
	On Po.product_id = Oi.product_id
Group by Po.category_english
Order by Total_orders desc
Limit 10; -- Top 10 categories by orders count

Select oi.seller_id, round(sum(Oi.price),2) as seller_revenue
From olist_orders_dataset_working O
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Where O.order_status = 'delivered'
Group by Oi.seller_id
Order by seller_revenue desc
Limit 10; -- Top 10 sellers by revenue

Select oi.seller_id, 
		round(sum(Oi.price),2) as seller_revenue, 
		round(sum(Oi.price) * 100.0 / 
			(Select SUM(Oi2.price)
				From olist_orders_dataset_working O2
				Join olist_order_items_dataset_working Oi2
					On O2.order_id = Oi2.order_id
				Where O2.order_status = 'delivered'), 
				2) as seller_revenue_contribution
From olist_orders_dataset_working O
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Where O.order_status = 'delivered'
Group by Oi.seller_id
Order by seller_revenue desc ; -- Seller's contribution to the revenue

-- =====================================================
-- Customer Experience Analysis
-- =====================================================

/*
Business Objective:
Understand customer satisfaction, delivery performance,
and review behavior across the marketplace.
*/

Select oi.seller_id, count(distinct(O.order_id)) as seller_total_orders
From olist_orders_dataset_working O
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Where O.order_status = 'delivered'
Group by Oi.seller_id
Order by seller_total_orders desc
Limit 10; -- Top 10 sellers by orders

Select Avg(delivery_time) as avg_delivery_time, Max(delivery_time) as long_delivery_time, min(delivery_time) as fast_delivery_time
From (Select order_id, datediff(order_delivered_customer_dt, order_purchase_ts) as delivery_time
		From olist_orders_dataset_working
		Where order_status = 'delivered') as delivery_timeline ; -- delivery days aggregators
        
Select order_id, delivery_time
From (Select order_id, datediff(order_delivered_customer_dt, order_purchase_ts) as delivery_time
		From olist_orders_dataset_working
		Where order_status = 'delivered') as delivery_timeline 
Order by delivery_time; -- Delivery days by orders 

Select customer_state, datediff(order_delivered_customer_dt, order_purchase_ts) as delivery_time
		From olist_orders_dataset_working O
        Join olist_customers_dataset_working C
			On O.customer_id = C.customer_id
		Where order_status = 'delivered'; -- Delivery days taken by states 
        
Select customer_state, Avg(delivery_time) as avg_delivery_time, Max(delivery_time) as long_delivery_time, min(delivery_time) as fast_delivery_time
From (Select customer_state, datediff(order_delivered_customer_dt, order_purchase_ts) as delivery_time
		From olist_orders_dataset_working O
        Join olist_customers_dataset_working C
			On O.customer_id = C.customer_id
		Where order_status = 'delivered') as delivery_timeline 
        Group by customer_state 
        Order by avg_delivery_time; -- Delivery aggregators by states
        
Select count(
			case 
				when order_delivered_customer_dt > order_estimated_delivery_dt then 1
                end) as late_deliveries
From olist_orders_dataset_working 
where order_status = 'delivered' ; -- Total late deliveries 

Select round(count(
			case 
				when order_delivered_customer_dt > order_estimated_delivery_dt then 1
                end) * 100.0 / count(*), 2) as late_delivery_percentage
From olist_orders_dataset_working 
where order_status = 'delivered' ; -- Late delivery percentage

Select Round(avg(delayed_days),2)
From (Select datediff(order_delivered_customer_dt, order_estimated_delivery_dt) as delayed_days
	From olist_orders_dataset_working
	where order_delivered_customer_dt > order_estimated_delivery_dt
    and order_status = 'delivered' ) as Late_delivery ; -- Avrage delivery delay
    
Select review_score, count(*) as reviews
From olist_order_reviews_dataset_working
Group by review_score 
Order by review_score ; -- Total reviews count by review score

Select review_score, count(*) as reviews, round(count(*) * 100.0 / (select count(*) from olist_order_reviews_dataset_working), 2) as review_percentage
From olist_order_reviews_dataset_working
Group by review_score 
Order by review_score ; -- Review percentage by review score

Select O.order_status,
       COUNT(*) as review_count
From olist_order_reviews_dataset_working R
Join olist_orders_dataset_working O
    On R.order_id = O.order_id
Group by O.order_status
Order by review_count desc; -- Review distribution by order status 

Select review_score,
       Count(*) as reviews
From olist_order_reviews_dataset_working R
Join olist_orders_dataset_working O
    On R.order_id = O.order_id
Where O.order_status = 'delivered'
Group by review_score
Order by review_score; -- Review count by review ratings

Select review_score,
       Count(*) as reviews,
       Round(Count(*) * 100.0 /
            (Select Count(*)
                From olist_order_reviews_dataset_working R
                Join olist_orders_dataset_working O
                    on R.order_id = O.order_id
                Where O.order_status = 'delivered'
            ),2) as review_percentage
From olist_order_reviews_dataset_working R
Join olist_orders_dataset_working O
    on R.order_id = O.order_id
Where O.order_status = 'delivered'
Group by review_score
Order by review_score; -- Review percentage by review ratings

Select review_score, count(*) as reviews
From olist_orders_dataset_working O
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where order_status = 'delivered'
	and  order_delivered_customer_dt > order_estimated_delivery_dt
Group by review_score
Order by review_score ; -- Late delivery review distribution

Select review_score, count(*) as reviews, 
			round(Count(*) * 100.0 / 
            (Select count(*) From olist_order_reviews_dataset_working)
            ,2) as late_delivery_ratings_percentage
From olist_orders_dataset_working O
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where order_status = 'delivered'
	and  order_delivered_customer_dt > order_estimated_delivery_dt
Group by review_score
Order by review_score ; -- Late delivery review percentage

Select review_score, count(*) as reviews, 
			round(Count(*) * 100.0 / 
            sum(count(*)) over(), 2) as late_delivery_ratings_percentage
From olist_orders_dataset_working O
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where order_status = 'delivered'
	and  order_delivered_customer_dt > order_estimated_delivery_dt
Group by review_score
Order by review_score ; -- Rating breakdown of late deliveries

With review_table as (Select review_score, count(*) as review_count, 
		count( case when order_delivered_customer_dt > order_estimated_delivery_dt then 1
				end) as late_delivery_reviews
		From olist_orders_dataset_working O
		Join olist_order_reviews_dataset_working R
				On O.order_id = R.order_id
		where O.order_status = 'delivered'
		Group by review_score)
Select
    review_score,
    review_count,
    round(review_count * 100 / SUM(review_count) over(), 2) as review_pct,
    late_delivery_reviews,
    round(late_delivery_reviews * 100 / SUM(review_count) over(), 2) as late_delivery_pct,
    round(late_delivery_reviews * 100 / review_count, 2) as late_delivery_review_pct
From review_table
Order by review_score; -- Review score distribution with late delivery metrics

Select review_score, round(avg(datediff(O.order_delivered_customer_dt, O.order_estimated_delivery_dt)), 2) as avg_delay
From olist_orders_dataset_working O
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_status = 'delivered'
Group by review_score
Order By review_score ; -- Average delivery performance by review score

Select review_score, round(avg(datediff(O.order_delivered_customer_dt, O.order_estimated_delivery_dt)), 2) as avg_delay
From olist_orders_dataset_working O
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_status = 'delivered'
	And O.order_delivered_customer_dt >
		o.order_estimated_delivery_dt
Group by review_score
Order By review_score ; -- Average delay for late delivery reviews

Select Po.product_category_name_english, 
		count(distinct(R.review_id)) as total_reviews, 
        round(avg(review_score), 2) as Avg_review_score
From olist_order_reviews_dataset_working R
Join olist_order_items_dataset_working Oi
	On R.order_id = Oi.order_id
Join ( Select P.product_id, P.product_category_name, Pc.product_category_name_english
		From olist_products_dataset_working P
        Join product_category_name_translati_working Pc
			On P.product_category_name = Pc.product_category_name) as Po
	On Oi.product_id = Po.Product_id 
Group by Po.product_category_name_english
Having count(distinct(R.review_id)) > 500
Order by Total_reviews desc ; -- Average review score by product category and count 

Select Po.product_category_name_english, 
		count(distinct(R.review_id)) as total_reviews, 
        round(avg(review_score), 2) as Avg_review_score
From olist_order_reviews_dataset_working R
Join olist_orders_dataset_working O
	On R.order_id = O.order_id
Join olist_order_items_dataset_working Oi
	On R.order_id = Oi.order_id
Join ( Select P.product_id, P.product_category_name, Pc.product_category_name_english
		From olist_products_dataset_working P
        Join product_category_name_translati_working Pc
			On P.product_category_name = Pc.product_category_name) as Po
	On Oi.product_id = Po.Product_id 
Where order_status = 'delivered'
Group by Po.product_category_name_english
Having count(distinct(R.review_id)) > 500
Order by Total_reviews desc ; -- Average review score and count by prodcut category delivered orders

Select C.customer_state, 
		count(distinct(R.review_id)) as total_reviews,
        Round(avg(R.review_score), 2) as Avg_review_score
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_status = 'delivered'
Group by C.customer_state
Having count(distinct(R.review_id)) >= 100
Order by total_reviews desc ; -- Average review score by customer states

Select Oi.seller_id, 
		count(distinct(O.order_id)) as total_orders,
        round(avg(R.review_score), 2) as avg_review_score
From olist_orders_dataset_working O 
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Join olist_order_items_dataset_working Oi
	On R.order_id = Oi.order_id
Where order_status = 'delivered'
Group by Oi.seller_id
Having count(distinct(O.order_id)) >= 500
Order by total_orders desc; -- Average review score by top sellers 

Select order_id,
       count(*) as items
From olist_order_items_dataset_working
Group by order_id
Having count(*) > 1
Limit 10;

Select order_id,
       order_item_id,
       product_id,
       price,
       freight_value
From olist_order_items_dataset_working
Where order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';

Select *
From olist_order_payments_dataset_working
Where order_id = '00143d0f86d6fbd9f9b38ab440ac16f5';

Select distinct(O.order_id), round(sum(oi.freight_value), 2) as freight_amount
From olist_orders_dataset_working O
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Where order_status = 'delivered'
Group by O.order_id ; -- Freight amount per order

Select R.review_score, round(avg(Freight_table.freight_amount), 2) as avg_freight_amount
From (Select distinct(O.order_id), round(sum(oi.freight_value), 2) as freight_amount
	From olist_orders_dataset_working O
	Join olist_order_items_dataset_working Oi
		On O.order_id = Oi.order_id
	Where order_status = 'delivered'
	Group by O.order_id) as Freight_table
Join olist_order_reviews_dataset_working R
	On Freight_table.order_id = R.order_id
Group by R.review_score
Order By R.review_score ; -- Average freight amount by review score

-- Root Cause Analysis

/* Business Question:
Does delivery performance influence customer satisfaction across states?
*/

/* Hypothesis:
States with longer delivery times may receive lower review scores.
*/
Select delivery_day_states.customer_state, avg_delivery_time, avg_review_score, total_orders
From (Select customer_state, Avg(delivery_time) as avg_delivery_time
		From (Select customer_state, datediff(order_delivered_customer_dt, order_purchase_ts) as delivery_time
				From olist_orders_dataset_working O
        		Join olist_customers_dataset_working C
					on O.customer_id = C.customer_id
				Where order_status = 'delivered') as delivery_timeline 
				group by customer_state ) as delivery_day_states
Join (Select C.customer_state as Cust_state, 
				count(distinct(R.review_id)) as total_reviews,
				Round(avg(R.review_score), 2) as Avg_review_score,
                count(distinct(O.order_id)) as total_orders
		From olist_orders_dataset_working O
		Join olist_customers_dataset_working C
			On O.customer_id = C.customer_id
		Join olist_order_reviews_dataset_working R
			On O.order_id = R.order_id
		Where O.order_status = 'delivered'
		Group by C.customer_state) as review_score_states
	On delivery_day_states.customer_state = review_score_states.Cust_state
group by delivery_day_states.customer_state
Order by total_orders desc ;

/* Insight:
The data shows a weak to moderate negative relationship.
Some states with slower deliveries have lower ratings,
but delivery time alone does not fully explain customer satisfaction.
Other factors may also influence customer ratings.
*/

/* Business Question:
Which sellers take longer than the marketplace average to process and hand over orders to carriers?
*/
Select Oi.seller_id,
		count(distinct(o.order_id)) as total_orders,
        round(avg(datediff(
					O.order_delivered_carrier_dt,
                    O.order_purchase_ts)), 2) as avg_order_processing_days,
		(Select round(avg(
				datediff(order_delivered_carrier_dt,
							order_purchase_ts)), 2)
			From olist_orders_dataset_working
            Where order_status = 'delivered' 
				And order_delivered_carrier_dt is not null) as avg_marketplace_processing_days,
		(round(avg(datediff(
					O.order_delivered_carrier_dt,
                    O.order_purchase_ts)), 2) - (Select round(avg(
				datediff(order_delivered_carrier_dt,
							order_purchase_ts)), 2)
			From olist_orders_dataset_working
            Where order_status = 'delivered' 
				And order_delivered_carrier_dt is not null)) as processing_difference
From olist_orders_dataset_working O
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Where O.order_status = 'delivered' 
	And O.order_delivered_carrier_dt is not null
Group by Oi.seller_id
Having count(distinct(O.order_id)) >= 100
Order by avg_order_processing_days desc ;

-- Hypothesis:
-- Some sellers take significantly longer than the marketplace average to hand orders over to carriers.

/* Business Question:
Do sellers with higher late-delivery rates tend to receive lower customer ratings?
*/
With seller_customer_performance as(
Select Oi.seller_id, 
		count(distinct(O.order_id)) as total_orders,
        count(distinct case
				when O.order_delivered_customer_dt >
						O.order_estimated_delivery_dt
				Then O.order_id
                end) as late_deliveries,
		round(avg(R.review_score), 2) as avg_rating
From olist_orders_dataset_working O 
Join olist_order_items_dataset_working Oi
	On O.order_id = Oi.order_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where order_status = 'delivered'
	And O.order_delivered_customer_dt is not null
Group by Oi.seller_id
Having count(distinct(O.order_id)) >= 100)
Select seller_id,
		total_orders,
        late_deliveries,
        round((late_deliveries * 100 / 
        total_orders), 2) as late_delivery_pct,
        avg_rating
From seller_customer_performance
Order by late_deliveries, avg_rating desc;

-- Hypothesis:
-- Sellers associated with higher late-delivery rates may receive lower customer ratings.

-- =====================================================
-- Customer Behavior Analysis
-- =====================================================

/*
Business Objective:
Understand purchasing behavior, repeat purchases,
customer lifetime value, and payment preferences.
*/

Select C.customer_unique_id, count(distinct(O.order_id)) as total_orders
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Where order_status = 'delivered'
Group by C.customer_unique_id
Order by total_orders desc ;

With customer_orders as
	(Select C.customer_unique_id,
            count(distinct(O.order_id)) as total_orders
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
	Where O.order_status in ('approved', 'processing', 'shipped', 'invoiced', 'delivered')
    Group by C.customer_unique_id),
customer_types as
	(Select 'One-Time' as customer_type,
            count(*) as customers
    From customer_orders
    Where total_orders = 1
    Union All
	Select 'Repeat' as customer_type,
            count(*) as customers
    From customer_orders
    Where total_orders > 1)
Select customer_type,
        customers,
        round(customers * 100.0 /
            sum(customers) over(),
            2) as customer_percentage
From customer_types; -- Total one time vs repeat customers and their percentage 

With Customer_orders as 
	(Select C.customer_unique_id, count(distinct(O.order_id)) as total_orders
	From olist_customers_dataset_working C
	Join olist_orders_dataset_working O
		On C.customer_id = O.customer_id
	Where O.order_status in ('approved', 'processing', 'shipped', 'invoiced', 'delivered')
	Group by C.customer_unique_id
	Order by total_orders desc)
Select total_orders,
		count(*) as customers
From Customer_orders
Group by total_orders
Order by total_orders desc; -- Customer order frequency

With Customer_life_table as 
	(Select C.customer_unique_id, 
			count(distinct(O.order_id)) as total_orders,
			sum(Op.payment_value) as total_revenue
	From olist_customers_dataset_working C
	Join olist_orders_dataset_working O
		On C.customer_id = O.customer_id
	Join olist_order_payments_dataset_working Op
		On O.order_id = Op.order_id
	Where O.order_status in ('approved', 'processing', 'shipped', 'invoiced', 'delivered')
	Group by C.customer_unique_id
	Order by total_orders desc ),
customer_frequency as
	(Select total_orders,
		count(*) as customers,
        round(sum(total_revenue),2) as customer_revenue
	From Customer_life_table
	Group by total_orders
	Order by total_orders desc)
Select total_orders,
		customers,
        customer_revenue,
        round(customer_revenue * 100 / 
				sum(customer_revenue) over(), 2) as customer_revenue_share
From customer_frequency
Order by total_orders desc ; -- Customer lifetime value and revenue contribution

With customer_orders as (
	Select C.customer_unique_id as Cust_id, count(distinct(O.order_id)) as total_orders
	From olist_customers_dataset_working C
	Join olist_orders_dataset_working O
		On C.customer_id = O.customer_id
	Where O.order_status in ('approved', 'processing', 'shipped', 'invoiced', 'delivered')
	Group by C.customer_unique_id
	Order by total_orders desc )
Select C2.customer_state,
        count(*) as customers,
        count(case
				when total_orders = 1
                then 1
                end ) as One_time_customers,
		count(case
				when total_orders > 1
                then 1
                end ) as repeat_customers,
		round(count(case 
				when total_orders > 1 then 1 end) * 100.0 /
                count(*), 2) as repeat_customer_pct
From customer_orders Co
Join olist_customers_dataset_working C2
	On Co.cust_id = C2.customer_unique_id
Group by C2.customer_state
Order by customers desc ; -- States by one time and repeat customer and their pct

With payment_table as(
	Select payment_type, 
			Count(distinct(O.order_id)) as total_orders,
			round(sum(Op.payment_value), 2) as total_revenue
	From olist_order_payments_dataset_working Op
	Join olist_orders_dataset_working O
		On O.order_id = Op.order_id
	Where O.order_status = 'delivered' 
	Group by payment_type)
Select payment_type,
		total_orders,
        round(total_orders * 100.0 / sum(total_orders) over(), 2) as total_order_pct,
        total_revenue,
        round(total_revenue * 100.0 / sum(total_revenue) over(), 2) as total_revenue_pct
From payment_table
Order by Total_revenue desc ; -- Total revenue and share of payment type 

Select payment_type, 
		count(distinct(O.order_id)) as total_orders,
        round(avg(Op.payment_value), 2) as avg_Transaction_value
From olist_order_payments_dataset_working Op
Join olist_orders_dataset_working O
	On Op.order_id = O.order_id
Where O.order_status = 'delivered' 
Group by payment_type
Order by avg_Transaction_value desc ; -- Payment type and avg payment transaction value per order

With Payments as(
	Select O.order_id, 
    Op.payment_type, 
    sum(Op.payment_value) as total_amount
	From olist_orders_dataset_working O
	Join olist_order_payments_dataset_working Op
		On O.order_id = Op.order_id
	Where O.order_status = 'delivered'
	Group by O.order_id, Op.payment_type)
Select payment_type,
		count(*) as total_orders,
        round(avg(total_amount), 2) as avg_order_value
From Payments
Group by payment_type
Order By avg_order_value desc; -- Average order value by payment types

Select O2.payment_type, 
		count(distinct(R.review_id)) as total_reviews,
        round(avg(R.review_score), 2) as avg_review_score
From (Select O.order_id,
			payment_type
	From olist_orders_dataset_working O
	Join olist_order_payments_dataset_working Op
		On O.order_id = Op.order_id
	Where O.order_status = 'delivered') O2
Join olist_order_reviews_dataset_working R
	On O2.order_id = R.order_id
Group by O2.payment_type
Order by avg_review_score ; -- Total reviews and avg rating for payment types

Select total_installments,
		round(avg(total_order_value), 2) as avg_order_value,
        count(*) as total_orders,
        round(count(*) * 100.0 /
			sum(count(*)) over(),2) as order_share_pct
From (Select O.order_id,
			round(sum(Op.payment_value), 2) as total_order_value,
			max(payment_installments) as total_installments
	From olist_orders_dataset_working O
	Join olist_order_payments_dataset_working Op
		On O.order_id = Op.order_id
	Where O.order_status = 'delivered'
	Group by O.order_id) as Installment
Group by total_installments
Order by avg_order_value desc ; -- Average order value by installment types 

-- =====================================================
-- Customer Churn Analysis
-- =====================================================

/*
Business Problem:
Customer retention is critical for long-term growth.
The objective is to identify churn patterns,
revenue at risk, and factors associated with churn.
*/

Select C.customer_unique_id,
		Min(O.order_purchase_ts) as first_order,
        Max(O.order_purchase_ts) as recenct_order,
        count(distinct(O.order_id)) as total_orders,
        round(sum(Op.payment_value), 2) as total_revenue
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where O.order_status in ('delivered', 'invoiced', 'shipped', 'processing', 'approved')
Group by customer_unique_id ; -- Customer base table

Select O.order_id, C.customer_unique_id, O.order_purchase_ts, O.order_status
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Group by O.order_id ; -- Order history table

Select
    min(order_purchase_ts) as Min_order_date,
    max(order_purchase_ts) as Max_order_date
From olist_orders_dataset_working; -- base date table

Select count(*) as rowx,
       count(distinct O.order_id) as orders
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
    On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
    On O.order_id = R.order_id
Where O.order_delivered_customer_dt is not null;

Select distinct O.order_id,
		C.customer_unique_id,
        O.order_purchase_ts,
        datediff(O.order_delivered_customer_dt,
					O.order_purchase_ts) as delivery_days,
		(case when O.order_delivered_customer_dt > 
					O.order_estimated_delivery_dt
                    then 1 else 0 end) as late_delivery_flag,
		R.review_score,
        c.customer_state
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_delivered_customer_dt is not null ; -- Customer experience table

Select O.order_id,
		C.customer_unique_id,
        O.order_status,
        O.order_purchase_ts
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id ;-- Base order table

With Customer_base as(
Select C.customer_unique_id,
		Min(O.order_purchase_ts) as first_order,
        Max(O.order_purchase_ts) as recenct_order,
        count(distinct(O.order_id)) as total_orders,
        round(sum(Op.payment_value), 2) as total_revenue
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where O.order_status in ('delivered', 'invoiced', 'shipped', 'processing', 'approved')
Group by customer_unique_id ),
Base_date as (
Select
    max(order_purchase_ts) as Max_order_date
From olist_orders_dataset_working )
Select Cb.*,
		Bd.Max_order_date,
        Datediff(Bd.Max_order_date, Cb.first_order) as Customer_tenure,
        Datediff(Bd.Max_order_date, Cb.recenct_order) as inactive_days,
        Case when
				datediff(Bd.Max_order_date,Cb.recenct_order) > 180
                then 1 else 0
                end  as churned_flag,
		case
			when datediff(Bd.Max_order_date, Cb.first_order) < 90 then '0-89'
			when datediff(Bd.Max_order_date, Cb.first_order) < 120 then '91-119'
            when datediff(Bd.Max_order_date, Cb.first_order) < 180 then '121-179'
			when datediff(Bd.Max_order_date, Cb.first_order) < 365 then '181-364'
            else '365+' 
            end as tenure_bucket
From Customer_base Cb
Cross join Base_date Bd ; -- Customer churn table CTE

With Customer_base as(
Select C.customer_unique_id,
		Min(O.order_purchase_ts) as first_order,
        Max(O.order_purchase_ts) as recenct_order,
        count(distinct(O.order_id)) as total_orders,
        round(sum(Op.payment_value), 2) as total_revenue
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where O.order_status in ('delivered', 'invoiced', 'shipped', 'processing', 'approved')
Group by customer_unique_id ),
Base_date as (
Select
    min(order_purchase_ts) as Min_order_date,
    max(order_purchase_ts) as Max_order_date
From olist_orders_dataset_working ),
Order_base as(
Select O.order_id,
		C.customer_unique_id,
        O.order_status,
        O.order_purchase_ts
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id ),
Customer_churn as 
( Select Cb.*,
		Bd.Max_order_date,
        Datediff(Bd.Max_order_date, Cb.first_order) as Customer_tenure,
        Datediff(Bd.Max_order_date, Cb.recenct_order) as inactive_days,
        Case when
				datediff(Bd.Max_order_date,Cb.recenct_order) > 180
                then 1 else 0
                end  as churned_flag,
		case
			when datediff(Bd.Max_order_date, Cb.first_order) < 90 then '0-89'
			when datediff(Bd.Max_order_date, Cb.first_order) < 120 then '91-119'
            when datediff(Bd.Max_order_date, Cb.first_order) < 180 then '121-179'
            when datediff(Bd.Max_order_date, Cb.first_order) < 365 then '181-364'
            else '365+'
            end as tenure_bucket
From Customer_base Cb
Cross join Base_date Bd )
Select tenure_bucket,
		count(*) as total_customers,
        round(count(*) * 100.0 /
				sum(count(*))  over(), 2) as tenure_bucket_pct
From Customer_churn
Group by tenure_bucket ; -- Customers and customer_pct by tenure bucket 

Create temporary table customer_churn as(
With Customer_base as(
Select C.customer_unique_id,
		Min(O.order_purchase_ts) as first_order,
        Max(O.order_purchase_ts) as recenct_order,
        count(distinct(O.order_id)) as total_orders,
        round(sum(Op.payment_value), 2) as total_revenue
From olist_customers_dataset_working C
Join olist_orders_dataset_working O
	On C.customer_id = O.customer_id
Join olist_order_payments_dataset_working Op
	On O.order_id = Op.order_id
Where O.order_status in ('delivered', 'invoiced', 'shipped', 'processing', 'approved')
Group by customer_unique_id ),
Base_date as (
Select
    min(order_purchase_ts) as Min_order_date,
    max(order_purchase_ts) as Max_order_date
From olist_orders_dataset_working ),
Order_base as(
Select O.order_id,
		C.customer_unique_id,
        O.order_status,
        O.order_purchase_ts
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id ),
Customer_churn as 
( Select Cb.*,
		Bd.Max_order_date,
        Datediff(Bd.Max_order_date, Cb.first_order) as Customer_tenure,
        Datediff(Bd.Max_order_date, Cb.recenct_order) as inactive_days,
        Case when
				datediff(Bd.Max_order_date,Cb.recenct_order) > 180
                then 1 else 0
                end  as churned_flag,
		case
			when datediff(Bd.Max_order_date, Cb.first_order) < 90 then '0-89'
			when datediff(Bd.Max_order_date, Cb.first_order) < 120 then '91-119'
            when datediff(Bd.Max_order_date, Cb.first_order) < 180 then '121-179'
            when datediff(Bd.Max_order_date, Cb.first_order) < 365 then '181-364'
            else '365+'
            end as tenure_bucket
From Customer_base Cb
Cross join Base_date Bd ) 
Select *
From customer_churn ) ; 

Select churned_flag,
		count(*) as total_customers
From customer_churn 
Group by churned_flag ; -- Count of churned and repeat customers

Select round(sum(churned_flag) * 100.0 /
			count(*), 2) as churned_pct
From Customer_churn ; -- Churn rate
-- Approximately 71% of customers were inactive for more than 180 days and were classified as churned.

Select churned_flag,
       count(*) as customers,
       round(avg(total_orders),2) as avg_orders,
       round(avg(total_revenue),2) as avg_revenue
From customer_churn
Group by churned_flag; -- Average revenue and orders by churn and repeat customers

Select churned_flag,
       sum(case when total_orders > 1 then 1 else 0 end) as repeat_customers,
       count(*) as customers,
       round(sum(
			case when total_orders > 1 then 1 else 0 end) * 100.0 /
           count(*),
           2) as repeat_pct
From customer_churn
Group by churned_flag; -- Total repeat customers rate in churned and repeat customers
-- Repeat purchasing behavior is extremely limited, with only about 3% of customers making more than one purchase.

Select total_orders,
       count(*) as customers
From customer_churn
Group by total_orders
Order by total_orders; -- Total customer count by order numbers
-- The customer base is heavily dominated by one-time buyers.
-- Approximately 97% of customers place only one order.

Select
    min(total_orders),
    max(total_orders),
    avg(total_orders)
From customer_churn; 

Select Cc.Churned_flag,
		round(avg(Ce.delivery_days), 2) as avg_delivery_time,
        round(sum(late_delivery_flag) * 100.0 /
			count(*), 2) as late_delivery_pct,
		round(avg(Ce.review_score), 2) as avg_review_score
From customer_churn_new Cc
Join (Select distinct O.order_id,
		C.customer_unique_id,
        O.order_purchase_ts,
        datediff(O.order_delivered_customer_dt,
					O.order_purchase_ts) as delivery_days,
		(case when O.order_delivered_customer_dt > 
					O.order_estimated_delivery_dt
                    then 1 else 0 end) as late_delivery_flag,
		R.review_score,
        c.customer_state
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_delivered_customer_dt is not null ) as Ce
	On Cc.customer_unique_id = Ce.customer_unique_id
Group by churned_flag ;
/*Churned customers experienced significantly poorer fulfillment performance:
1. Average delivery time was 13.7 days versus 9.5 days for active customers.
2. Late delivery rate was 8.84% versus 5.99%.
3. Average review score was 4.10 versus 4.29.*/

Select Ce.customer_state,
		count(distinct(Cc.customer_unique_id)) as total_customers,
        count(distinct case
					when churned_flag = 1 then Cc.customer_unique_id
					end) as churned_customers,
		round(count(distinct case
					when churned_flag = 1 then Cc.customer_unique_id
					end) * 100.0 / count(distinct Cc.customer_unique_id),
                    2) as churned_pct
From customer_churn Cc
Join (Select distinct O.order_id,
		C.customer_unique_id,
        O.order_purchase_ts,
        datediff(O.order_delivered_customer_dt,
					O.order_purchase_ts) as delivery_days,
		(case when O.order_delivered_customer_dt > 
					O.order_estimated_delivery_dt
                    then 1 else 0 end) as late_delivery_flag,
		R.review_score,
        c.customer_state
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_delivered_customer_dt is not null ) as Ce
	On Cc.customer_unique_id = Ce.customer_unique_id
Group by customer_state 
Order by total_customers desc
limit 15; -- State level churn analysis

Select churned_flag,
    round(sum(total_revenue), 2) as total_revenue_amt,
    round(avg(total_revenue), 2) as avg_revenue_amt,
    round(sum(total_revenue) * 100.0 /
        sum(sum(total_revenue)) over(), 2) as total_revenue_pct
From customer_churn_new
Group by churned_flag; -- Revenue lost by churn

Select churned_flag,
       count(*) as customers,
       round(avg(total_revenue),2) as avg_customer_revenue,
       round(avg(total_orders),2) as avg_orders,
       round(sum(total_revenue),2) as total_revenue
From customer_churn_new
Group by churned_flag; -- Average orders and revenue by churned flag

Select tenure_bucket,
    count(*) as customers,
    sum(churned_flag) as churned_customers,
    round(sum(churned_flag) * 100.0 /
        count(*), 2) as churn_rate
From customer_churn_new
Group by tenure_bucket
Order by churn_rate desc; -- Customer churn rate by tenure bucket 

/******************************************************
Feature Engineering:
Customer Churn Analytical Table
******************************************************/

/*
Purpose:
Create a customer-level analytical table containing:

- Customer Lifecycle Metrics
- Revenue Metrics
- Churn Classification
- Tenure Metrics

This table serves as the primary dataset
for churn analysis and dashboard reporting.
*/

Create table customer_churn_new as
With Customer_base as (
    Select
        C.customer_unique_id,
        MIN(C.customer_state) as customer_state,
        MIN(O.order_purchase_ts) as first_order,
        MAX(O.order_purchase_ts) as recenct_order,
        COUNT(distinct O.order_id) as total_orders,
        ROUND(SUM(Op.payment_value), 2) as total_revenue
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
    Join olist_order_payments_dataset_working Op
        On O.order_id = Op.order_id
    Where O.order_status in
        ('delivered', 'invoiced', 'shipped', 'processing', 'approved')
    Group by C.customer_unique_id
),
Base_date as (
    Select
        MIN(order_purchase_ts) as Min_order_date,
        MAX(order_purchase_ts) as Max_order_date
    From olist_orders_dataset_working
),
Customer_churn as (
    Select
        Cb.*,
        Bd.Max_order_date,
        DATEDIFF(Bd.Max_order_date, Cb.first_order) as Customer_tenure,
        DATEDIFF(Bd.Max_order_date, Cb.recenct_order) as inactive_days,
        Case
            When DATEDIFF(Bd.Max_order_date, Cb.recenct_order) > 180
            Then 1
            Else 0
        End as churned_flag,
        Case
            When DATEDIFF(Bd.Max_order_date, Cb.first_order) < 90 then '0-89'
            When DATEDIFF(Bd.Max_order_date, Cb.first_order) < 120 then '91-119'
            When DATEDIFF(Bd.Max_order_date, Cb.first_order) < 180 then '121-179'
            When DATEDIFF(Bd.Max_order_date, Cb.first_order) < 365 then '181-364'
            Else '365+'
        End as tenure_bucket
	From Customer_base Cb
    Cross join Base_date Bd)
Select *
From Customer_churn;

With first_order as (
    Select
        C.customer_unique_id,
        O.order_id,
        row_number() over (
            partition by C.customer_unique_id
            Order by O.order_purchase_ts) as rn
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
    Where O.order_status = 'delivered'
)
Select
    Ch.churned_flag,
    Count(*) as customers,
    Round(avg(R.review_score), 2) as avg_first_order_review
From first_order Fo
Join olist_order_reviews_dataset_working R
    On Fo.order_id = R.order_id
Join customer_churn_new Ch
    On Fo.customer_unique_id = Ch.customer_unique_id
Where Fo.rn = 1
Group by Ch.churned_flag; -- First order review score vs churn

With first_order as (
    Select
        C.customer_unique_id,
        O.order_id,
        O.order_purchase_ts,
        O.order_delivered_customer_dt,
        row_number() over (
            partition by C.customer_unique_id
            Order by O.order_purchase_ts) as rn
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
    Where O.order_status = 'delivered'
)
Select
    Ch.churned_flag,
    count(*) as customers,
    round(
        Avg(datediff(
                Fo.order_delivered_customer_dt,
                Fo.order_purchase_ts
            )),2) as avg_first_delivery_days
From first_order Fo
Join customer_churn_new Ch
    On Fo.customer_unique_id = Ch.customer_unique_id
Where Fo.rn = 1
Group by Ch.churned_flag; -- First order delivery days vs churn

With first_order as (
    Select
        C.customer_unique_id,
        O.order_id,
        O.order_delivered_customer_dt,
        O.order_estimated_delivery_dt,
        row_number() over (
            partition by C.customer_unique_id
            Order by O.order_purchase_ts
        ) as rn
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
    Where O.order_status = 'delivered'
)
Select
    Ch.churned_flag,
    count(*) as customers,
    sum(case
            when Fo.order_delivered_customer_dt >
                 Fo.order_estimated_delivery_dt
            then 1
            else 0
        end) as late_first_orders,
    round( 100.0 *
        sum(case
                when Fo.order_delivered_customer_dt >
                     Fo.order_estimated_delivery_dt
                then 1
                else 0
            end) / count(*),
        2) as late_first_order_pct
From first_order Fo
Join customer_churn_new Ch
    On Fo.customer_unique_id = Ch.customer_unique_id
Where Fo.rn = 1
Group by Ch.churned_flag; -- First order late delivery rate vs churn

Select
    SUM(Case when inactive_days > 90 then 1 else 0 end) * 100.0 / COUNT(*) as churn_90,
    SUM(Case when inactive_days > 120 then 1 else 0 end) * 100.0 / COUNT(*) as churn_120,
    SUM(Case when inactive_days > 180 then 1 else 0 end) * 100.0 / COUNT(*) as churn_180
From customer_churn_new; -- Churn % by different segments

Select churned_flag,
       round(avg(customer_tenure),2) as avg_tenure
From customer_churn_new
Group by churned_flag; -- Average tenure days by churn status

Select
    Case
        When total_revenue < 100 then '0-99'
        When total_revenue < 200 then '100-199'
        When total_revenue < 300 then '200-299'
        When total_revenue < 400 then '300-399'
        When total_revenue < 500 then '400-499'
        Else '500+'
    End as revenue_bucket,
    COUNT(*) as customers,
    ROUND(avg(total_revenue),2) as avg_revenue,
    ROUND(SUM(total_revenue),2) as total_revenue
From customer_churn_new
Group by revenue_bucket
Order by
    Case revenue_bucket
        When '0-99' then 1
        When '100-199' then 2
        When '200-299' then 3
        When '300-399' then 4
        When '400-499' then 5
        Else 6
    End;

Create table customer_experience as(
Select distinct O.order_id,
		C.customer_unique_id,
        O.order_purchase_ts,
        datediff(O.order_delivered_customer_dt,
					O.order_purchase_ts) as delivery_days,
		(case when O.order_delivered_customer_dt > 
					O.order_estimated_delivery_dt
                    then 1 else 0 end) as late_delivery_flag,
		R.review_score,
        c.customer_state
From olist_orders_dataset_working O
Join olist_customers_dataset_working C
	On O.customer_id = C.customer_id
Join olist_order_reviews_dataset_working R
	On O.order_id = R.order_id
Where O.order_delivered_customer_dt is not null) ;

Create table customer_first_experience as
With first_order as (
    Select
        C.customer_unique_id,
        O.order_id,
        O.order_purchase_ts,
        O.order_delivered_customer_dt,
        O.order_estimated_delivery_dt,
        row_number() over (
            partition by C.customer_unique_id
            order by O.order_purchase_ts
        ) as rn
    From olist_customers_dataset_working C
    Join olist_orders_dataset_working O
        On C.customer_id = O.customer_id
    Where O.order_status = 'delivered'
)
Select
    Fo.customer_unique_id,
    Ch.customer_state,
    Ch.churned_flag,
    Fo.order_id,
    datediff(
        Fo.order_delivered_customer_dt,
        Fo.order_purchase_ts
    ) as first_delivery_days,
    case
        when Fo.order_delivered_customer_dt >
             Fo.order_estimated_delivery_dt
        then 1
        else 0
    end as first_late_delivery_flag,
	R.review_score as first_review_score
From first_order Fo
Join customer_churn_new Ch
    On Fo.customer_unique_id = Ch.customer_unique_id
Left join olist_order_reviews_dataset_working R
    On Fo.order_id = R.order_id
Where Fo.rn = 1;

