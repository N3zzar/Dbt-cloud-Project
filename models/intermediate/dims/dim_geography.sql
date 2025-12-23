{{ config(
    tags=['intermediate', 'dimension']
) }}

with mapping as (
    select
        state_full.state_abbrev as state_abbrev,
        state_full.state_full as state_full
    from {{ ref('state_full') }}
),

geo as (
    select
        geolocation_zip_code as zip_code,
        avg(geolocation_lat) as latitude,
        avg(geolocation_lng) as longitude,
        any_value(geolocation_city) as city,
        upper(trim(any_value(geolocation_state))) as state_abbrev
    from {{ ref('stg_geolocation') }}
    where geolocation_lat between -90 and 90
      and geolocation_lng between -180 and 180
    group by 1
)

select
    g.zip_code,
    g.latitude,
    g.longitude,
    g.city,
    g.state_abbrev,
    m.state_full
from geo g
left join mapping m using (state_abbrev)
