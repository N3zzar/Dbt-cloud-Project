{%- macro cast_to_timestamp(column_list) -%}
    {# 
        column_map: a dictionary of old_name → new_name
        Example:
        {
            "order_purchase_timestamp": "purchased_ts",
            "order_approved_at": "approved_ts"
        }
    #}

    {%- set expressions = [] -%}

    {%- for old, new in column_list.items() -%}
        {%- do expressions.append("cast(" ~ old ~ " as timestamp) as " ~ new) -%}
    {%- endfor -%}

    {{- expressions | join(",\n        ") -}}
{%- endmacro -%}


