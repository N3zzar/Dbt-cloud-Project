{% macro get_current_date() %}
    {% if var('use_fixed_today', false) %}
        date("{{ var('fixed_today') }}")
    {% else %}
        CURRENT_DATE()
    {% endif %}
{% endmacro %}