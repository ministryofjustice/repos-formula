/var/tmp/sensu.key:
  file:
    - managed
    - source: salt://repos/keys/sensu.key


sensu-apt-key:
  cmd:
    - run
    - name: apt-key add /var/tmp/sensu.key
    - unless: apt-key list | grep '2048R/7580C77F'


sensu-deb:
  file.managed:
    - order: 0
    - contents: deb http://repos.sensuapp.org/apt sensu main
    - name: /etc/apt/sources.list.d/sensu.list
    - require:
      - cmd: sensu-apt-key
    - require_in:
      - pkg.*
    - watch_in:
      - cmd: apt_get_update
