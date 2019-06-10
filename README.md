# Playbooks to Copy CoreMedia Database Contents from one Environment to another

`coremedia-db-transfer`

The [Ansible][ansible] playbook in this repository is intended for minimalistic
transfer of the Contents from one [CoreMedia][coremedia] CMS-9 (or may be 
LiveContext3) Environment like a Production Environment to another like a Test 
Environment via Database Tooling and additional CoreMedia specific steps to
resynchronize all of the involved components.

Find mirrors of this repository at [gitlab][gitlab] and [github][github].


## Setup of the Environment

We rely on the roles `prodm`, `testm`, `testb`.

`prodm` is the role, where we take a backup from `Content Management Server` 
and `Master Live Server`.

`testm` is the role to install the backup into `Content Management Server` and 
`Master Live Server` and re-create indexes in the local `Solr` instance for
`Content Feeder` and `CAEFeeder Preview`

The role `testb` holds the live side with `Replication Live Server` and a `Solr`
index for `CAEFeeer Live`. Those are both emptied and created anew.


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
created. Use scp instead.


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

Let the hosts in the role `testb` intended to hold `Replication Live Servers`
and life CAEFeeder Solr Indexes know, that everything they now is outdated.
Empty the databases, replicate everything anew and recreate index.


## Known Limitations

This Playbook does not deal with MongoDB contents like elastic social or 
studio data, which is considered transient in our projects.

This Playbook does no restart the various components relying on the servers
storing data - solr or content server.

Also Timing is an issue not dealt with. So, restart of feeders is not delayed,
and the end of the complete repository replay is not waited for. So a subsequent
changing the runlevel in the Replication Live Servers has to be done manually.

## Feedback

Please use the [issues][issues] section of this repository at [github][github] 
for feedback. 

[ansible]: https://www.ansible.com/
[coremedia]: https://www.coremedia.com/
[issues]: https://github.com/provocon/coremedia-db-transfer/issues
[github]: https://github.com/provocon/coremedia-db-transfer
[gitlab]: https://gitlab.com/provocon/coremedia-db-transfer
