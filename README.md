# Playbooks to Copy CoreMedia Database Contents from one Environment to another

`coremedia-db-transfer`

The [Ansible][ansible] playbook in this repository is intended for minimalistic
transfer of the Contents from one [CoreMedia][coremedia] CMS-9 (and may be
later including LiveContext3) Environment like a Production Environment to
another like a Test Environment via Database Tooling and additional CoreMedia
specific steps to resynchronize all of the involved components.

For [CoreMedia CMCC][coremedia] on cloud services, a similar result can be
obtained with request to operations staff. Only use the playbooks in the
repository for on premises scenarios.


## Availability

The home of the playbooks lives at [Codeberg][codeberg] with
mirrors at [GitLab][gitlab] and [GitHub][github]. For references to the
repository, please prefer [Codeberg][codeberg] when possible.


## Feedback

Feel invited to use the [issues][issues] section of this repository at
[Codeberg][codeberg] for feedback.


## Setup of the Environment

We rely on the roles `prodm`, `testm`, `testb`.

`prodm` is the role, where we take a backup from `Content Management Server`
and `Master Live Server`.

`testm` is the role to install the backup into `Content Management Server` and
`Master Live Server` and re-create indexes in the local `Solr` instance for
`Content Feeder` and `CAE Feeder Preview`.

The role `testb` holds the live side with `Replication Live Server` and a
`Solr` index for `CAE Feeer Live`. Those are both emptied and created anew.


## Preparation

Configure relevant hosts in `inventory.properties` or your global 
[Ansible][ansible] hosts file (if you haven't done so) and make sure that
SSH-Access to the hosts works.


## Usage

Run with: 

```
ansible-playbook -i inventory.properties backup.yml
```

To create a backup of the `Content Management Server` and `Master Live Server`.
Fetching is commented out since it is likely to fail with the large files
created. Use `scp` instead.


```
ansible-playbook -i inventory.properties restore.yml
```

Push the backup of `Content Management Server` and `Master Live Server` from
your local directory (Mind the default for the backup_dir) to the management
host of the requested environment, stop servers and feeder, restore the backup,
rebuild the indexes.

```
ansible-playbook -i inventory.properties postprocess.yml
```

Let the hosts in the role `testb` which are intended to hold
`Replication Live Servers` and life CAE Feeder Solr Indexes know, that
everything they currently contain is now outdated. Thus, empty the databases,
replicate everything anew and recreate index.


## Known Limitations

This Playbook does not deal with MongoDB contents like elastic social or 
studio data, which is considered transient in our projects.

This Playbook does not restart the various components relying on the servers
storing data - Solr or Content Server.

Also, timing is an issue not dealt with. So, restart of feeders is not delayed,
and the end of the complete repository replay is not waited for. So check the 
`runlevel` in the Replication Live Servers and potential related problems and
delays manually in the log. (As you will always need to check the logs.)


[ansible]: https://www.ansible.com/
[coremedia]: https://www.coremedia.com/
[issues]: https://codeberg.org/provocon/coremedia-db-transfer/issues
[codeberg]: https://codeberg.org/provocon/coremedia-db-transfer
[gitlab]: https://gitlab.com/provocon/coremedia-db-transfer
[github]: https://github.com/provocon/coremedia-db-transfer
