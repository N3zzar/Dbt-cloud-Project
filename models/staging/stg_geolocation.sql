-- stg_geolocation.sql

with 

source as (
    select *
    from {{ source ('raw', 'olist_geolocation_dataset') }}
)

select * from source