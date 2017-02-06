{% from 'docker/map.jinja' import volume with context %}
{% set local = volume.driver.local %}

{% for key, value in local.get('volumes').iteritems() %}

{% set test_vol_cmd = 'docker volume ls | grep -E -q "^local\s+' ~ key ~ '$"' %}

{% set create_vol_cmd = 'docker volume create --driver=local --name=' ~ key %}


{% if salt['cmd.retcode'](cmd=test_vol_cmd, python_shell=true)|int != 0 %}

create-docker-volume-{{ key }}:
  cmd.run:
    - name: {{ create_vol_cmd }} {%- if value is not none %} {%- for v_key, v_val in value.iteritems() %} --opt={{ v_key }}={{ v_val }} {%- endfor %} {%- endif %}

{% endif %}

{% endfor %}
