/var/tmp/dsd-apt.key:
  file.managed:
    - source: salt://repos/keys/dsd-apt.key


dsd-apt-key:
  cmd.run:
    - name: apt-key add /var/tmp/dsd-apt.key
    - unless: apt-key list | grep DSD
    - require:
      - file: /var/tmp/dsd-apt.key


dsd-deb:
  file.managed:
    - order: 0
    - contents: deb [arch={{ grains['osarch'] }}] http://repo1.dsd.io/ {{ grains['oscodename'] }} main
    - name: /etc/apt/sources.list.d/dsd.list
    - require:
      - cmd: dsd-apt-key
    - require_in:
      - pkg.*
    - watch_in:
      - cmd: apt_get_update
