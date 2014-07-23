include:
  - .postgresql
  - .sensu
  - .dsd

# This should be watched from the file.managed state that adds the file to
# /etc/apt/sources.list.d/ - DONT USE pkgrepo.managed.
apt_get_update:
  cmd.wait:
    - name: apt-get update
