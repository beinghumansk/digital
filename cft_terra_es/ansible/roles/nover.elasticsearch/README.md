Ansible role for ElasticSearch
=========

This role installs ElasticSearch onto Ubuntu machines

Requirements
------------

Ansible and an Ubuntu Target machine

Role Variables
--------------

Currently you can set the bind address and the listening port. Defaults are localhost and 9200 

```yaml
elasticsearch_bind_address: "localhost"
elasticsearch_http_port: 9200
```

Change `elasticsearch_bind_address` to `0.0.0.0` to allow connections from everywhere

Dependencies
------------

Depends on `nover.java8` as elastic search does not run well with open-jdk

Example Playbook
----------------

You can use the role like this in your playbooks
```yaml
- hosts: servers
  roles:
      - { role: nover.elasticsearch }
  vars_files:
      vars/elasticsearch.yml
```

Where `vars/elasticsearch.yml` contains your overrides for the role.

License
-------

GitHub The Unlicense