-- stg_geolocation.sql
{{ config(tags=["staging", "olist"]) }}

with 

source as (
    select *
    from {{ source ('raw', 'olist_geolocation_dataset') }}
),

renamed as (
    select 
        trim(cast(geolocation_zip_code_prefix as string)) as geolocation_zip_code,
        cast(geolocation_lat as numeric) as geolocation_lat,
        cast(geolocation_lng as numeric) as geolocation_lng,
        cast(geolocation_city as string) as geolocation_city,
        cast(geolocation_state as string) as geolocation_state
    from source)

select * from renamed