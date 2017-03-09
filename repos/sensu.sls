/var/tmp/sensu.key:
  file:
    - managed
    - source: salt://repos/keys/sensu.key


sensu-apt-key:
  cmd:
    - run
    - name: apt-key add /var/tmp/sensu.key
    - unless: apt-key list | grep '2048R/7580C77F.*expires'

sensu-deb:
  pkgrepo.absent:
    - humanname: Sensu repo
    - name: deb http://repos.sensuapp.org/apt sensu main
    - file: /etc/apt/sources.list.d/sensu.list
    - require:
      - cmd: sensu-apt-key
    - require_in:
      - pkg.*

sensu-deb2:
  pkgrepo.managed:
    - humanname: Sensu repo 2017
    - name: deb https://sensu.global.ssl.fastly.net/apt {{ salt['grains.get']('oscodename', 'trusty') }} main
    - file: /etc/apt/sources.list.d/sensu.list
    - require:
      - cmd: sensu-apt-key
    - require_in:
      - pkg.*
