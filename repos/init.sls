/var/tmp/postgresql.key:
  file.managed:
    - source: salt://repos/keys/postgresql.key

pgsql-apt-key:
  cmd:
    - run
    - name: apt-key add /var/tmp/postgresql.key
    - require:
      - file: /var/tmp/postgresql.key
    - unless: apt-key list | grep '4096R/ACCC4CF8'

postgres-deb:
  pkgrepo.managed:
    - humanname: PostgreSQL deb repository
    - name: deb http://apt.postgresql.org/pub/repos/apt/ precise-pgdg main
    - file:  /etc/apt/sources.list.d/pgdg.list
    - require:
      - cmd: pgsql-apt-key
    - require_in:
      - pkg.*

/var/tmp/dsd-apt.key:
  file.managed:
    - source: salt://repos/keys/dsd-apt.key

dsd-apt-key:
  cmd:
    - run
    - name: apt-key add /var/tmp/dsd-apt.key


dsd-deb:
  pkgrepo.managed:
    - humanname: DSD Apt package repo
    - name: deb [arch={{ grains['osarch'] }}] http://repo1.dsd.io/ {{ grains['oscodename'] }} main
    - file: /etc/apt/sources.list.d/dsd.list
    - require:
      - cmd: dsd-apt-key
    - require_in:
      - pkg.*

dsd-custom-deb:
    pkgrepo.managed:
    - humanname: DSD Apt custom package repo
    - name: deb [arch=amd64] http://repo1.dsd.io/ precise main
    - file: /etc/apt/sources.list.d/dsd-custom.list



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
  pkgrepo.managed:
    - humanname: Sensu repo
    - name: deb http://repos.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list.d/sensu.list
    - require:
      - cmd: sensu-apt-key
    - require_in:
      - pkg.*
