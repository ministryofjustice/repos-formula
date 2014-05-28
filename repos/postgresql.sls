/var/tmp/postgresql.key:
  file.managed:
    - source: salt://repos/keys/postgresql.key


pgsql-apt-key:
  cmd.run:
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
