-- Question 39
-- Table: Prices

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | start_date    | date    |
-- | end_date      | date    |
-- | price         | int     |
-- +---------------+---------+
-- (product_id, start_date, end_date) is the primary key for this table.
-- Each row of this table indicates the price of the product_id in the period from start_date to end_date.
-- For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

-- Table: UnitsSold

-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | product_id    | int     |
-- | purchase_date | date    |
-- | units         | int     |
-- +---------------+---------+
-- There is no primary key for this table, it may contain duplicates.
-- Each row of this table indicates the date, units and product_id of each product sold. 
 

-- Write an SQL query to find the average selling price for each product.

-- average_price should be rounded to 2 decimal places.

-- The query result format is in the following example:

-- Prices table:
-- +------------+------------+------------+--------+
-- | product_id | start_date | end_date   | price  |
-- +------------+------------+------------+--------+
-- | 1          | 2019-02-17 | 2019-02-28 | 5      |
-- | 1          | 2019-03-01 | 2019-03-22 | 20     |
-- | 2          | 2019-02-01 | 2019-02-20 | 15     |
-- | 2          | 2019-02-21 | 2019-03-31 | 30     |
-- +------------+------------+------------+--------+
 
-- UnitsSold table:
-- +------------+---------------+-------+
-- | product_id | purchase_date | units |
-- +------------+---------------+-------+
-- | 1          | 2019-02-25    | 100   |
-- | 1          | 2019-03-01    | 15    |
-- | 2          | 2019-02-10    | 200   |
-- | 2          | 2019-03-22    | 30    |
-- +------------+---------------+-------+

-- Result table:
-- +------------+---------------+
-- | product_id | average_price |
-- +------------+---------------+
-- | 1          | 6.96          |
-- | 2          | 16.96         |
-- +------------+---------------+
-- Average selling price = Total Price of Product / Number of products sold.
-- Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
-- Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96

-- Solution
Select d.product_id, round((sum(price*units)+0.00)/(sum(units)+0.00),2) as average_price
from(
Select *
from prices p
natural join 
unitssold u
where u.purchase_date between p.start_date and p.end_date) d
group by d.product_id

-- 加上错误代码
-- 1、非聚合字段不能groupby
select distribute_no, warehouse_no,dim_store_name from  app.app_batch_assign_aa_mid where dt = sysdate(-2) GROUP by warehouse_no,distribute_no;
-- 2、不指定是哪个主表的字段
select * from app.app_batch_no_aa_feature  order by dt desc
select 
(select distribute_no, warehouse_no,dim_store_name from  app.app_batch_assign_aa_mid where dt = sysdate(-2) GROUP by warehouse_no,distribute_no) a
inner join (
select * from app.app_batch_no_aa_warehouse  where dt = sysdate(-1)
)b on a.distribute_no = b.distribute_no and a.warehouse_no = b.warehouse_no;
-- 3、窗口函数
select 
-- sku总数
sum(detail.picking_qty) over(partition by detail.distribute_no, detail.warehouse_no, detail.task_page_no) as total_sku
from 
(select * from fdm.fdm_wms5_report_picking_task_d_chain where dp = 'ACTIVE'
and substr(finish_time, 1, 10) = sysdate(-1);
) detail 
-- 4、lateral
select create_date,warehouse_no,distribute_no,order_no,type from 
 (
 select substr(create_date,1,10) create_date,warehouse_no,distribute_no, assign_batch_orders_actual,type from fdm.fdm_wms5_report_ob_assign_batch_log_statistics_chain where    start_date<=sysdate(-1) and end_date>sysdate(-1)  --AND type = 'alg'
 and substr(create_date,1,10)>='2021-10-15'
 group by create_date,warehouse_no,distribute_no, assign_batch_orders_actual,type
 ) a lateral view explode( split ( assign_batch_orders_actual , ' ' ) ) b as order_no 
-- 5、中文逗号
，，，，
-- 加上错误代码
