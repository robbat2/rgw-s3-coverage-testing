TODO: write more instructions

To build the test environment (using script): (Starts both ceph-demo and s3-tests containers)
./create-container

To build the test environment (using docker-compose): (Starts both ceph-demo and s3-tests containers)
```
docker-compose up -d
```

To run tests, us `docker run ceph/s3-tests-image` prefix with appropriate flags as
mentioned in s3-tests repository. For example:
```
docker run ceph/s3-tests-image -v -a '!fails_on_rgw,!lifecycle_expiration,!fails_strict_rfc2616'
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
# ./create-container || ./start-container
```

Debugging:
----------
Check out `docker logs ceph-demo`
