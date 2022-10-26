
{% macro model_to_csv() %}
    copy {{ this }} to 'solution_outputs/{{ this.identifier }}_output.csv' with (header 1, delimiter ',');
{% endmacro %}
