# RGW-S3 coverage testing

To build environment follow the instructions below:
- ``Scripts (stable)``: The script **bootstrap** starts a ceph/ceph-demo cluster in a container and also an ceph/s3-tests container. It also automates generating coverage reports (JSON+XML+HTML) and a XML output of tests that ran (nose-output.xml). 

A sample configuration file named ``s3tests.conf.SAMPLE`` has been provided in this repo which serves as the configuration file for running s3tests. Make changes in the ``.SAMPLE`` file itself, boostrap script would generate corresponding ``.conf`` file for you with appropriate configurations.

The scripts takes in arguments of the section of s3-tests to run along with nosetests.
The boostrap script already includes the prefix ``
S3TEST_CONF=your.conf ./virtualenv/bin/nosetests -v``.The corresponding section of tests to run that comes after the above command is provided as argument to the bootstrap script.

For example, if you want to run all the s3-tests like this:
```
S3TEST_CONF=your.conf ./virtualenv/bin/nosetests
```
Then simply run:
```
./bootstrap
```
If you want to specify which directory of tests to run like this:
```
S3TEST_CONF=your.conf ./virtualenv/bin/nosetests s3tests.functional
```
Then run:
```
./bootstrap s3tests.functional
```
If you want to specify which file of tests to run like this:
```
S3TEST_CONF=your.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3
```
Then run:
```
./bootstrap s3tests.functional.test_s3
```
If you want to specify which test to run like this:
```
S3TEST_CONF=your.conf ./virtualenv/bin/nosetests s3tests.functional.test_s3:test_bucket_list_empty
```
Then run:
```
./bootstrap s3tests.functional.test_s3:test_bucket_list_empty
```
To gather a list of tests being run, run this:
```
./bootstrap --collect-only
```
- ``Docker-compose (WIP)``: To start the ceph cluster and the s3-tests container simply run the following command to bootstrap both the services in docker-compose. It's still WIP, features to be added.
```
docker-compose up -d
```

Requirements:
-------------
Your Linux system must have a directory at /mnt/ceph that is writable to the
Ceph container.

If you use LVM, you might want to create this as a dedicated space, so it can't
accidently get too big and impact your system.

```bash
# vg=$(vgs -o vgname -q  --noheadings   --readonly  )
# lvcreate -n mnt_ceph -L 10g ${vg}
# mkfs.xfs /dev/${vg}/mnt_ceph
# mkdir /mnt/ceph
# mount /dev/${vg}/mnt_ceph /mnt/ceph
# ./bootstrap
```

Debugging:
----------
Check out `docker logs ceph-demo`
