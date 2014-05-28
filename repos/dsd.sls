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
  pkgrepo.managed:
    - humanname: DSD Apt package repo
    - name: deb [arch={{ grains['osarch'] }}] http://repo1.dsd.io/ {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/dsd.list
    - require:
      - cmd: dsd-apt-key
    - require_in:
      - pkg.*
