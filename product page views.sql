-- web
select 
		ss.dt, 
		coalesce(pv.page_id, cast(regexp_extract(pv.url, '(.*pv~)(\d+)(.*)', 2) as bigint)) house_id,
		count(*) product_views,
		count(if(page_behavior = 'VIEW_PRODUCT', 1, null)) view_products,
		count(if(page_behavior = 'pvp', 1, null)) pvps,
		count(distinct ss.session_id) n_sessions
		
from l2.session_summary_daily ss
join l2.page_views_daily pv
on ss.dt=pv.dt and ss.session_id =pv.session_id
where ss.dt >= '2022-05-01'
    and ss.site_id=101 
    and pv.dt >= '2022-05-01'
    and pv.site_id=101 
    and pv.page_behavior in ('VIEW_PRODUCT','pvp')
group by 1, 2


-- app
select 
	cast(ce.object_id as bigint) house_id,
	count(*) pv,
	count(distinct ms.session_id) n_sessions
from l2.mobile_summary_daily ms -- main app table excluding bot traffics
inner join l2.mobile_client_event_daily ce
on ms.dt = ce.dt and ms.session_id = ce.session_id
where ms.dt >= '2022-05-01'
and ms.country = 'US'
and ce.entity_type = 'Product'
group by 1