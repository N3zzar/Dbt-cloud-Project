{% macro unknown_to_other(column_name, new_column_name) %}
    case
        when {{ column_name }} is null or {{ column_name }} = 'unknown'
            then 'other'
        else lower(trim({{ column_name }}))
    end as {{ new_column_name }}
{% endmacro %}
