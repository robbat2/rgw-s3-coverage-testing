TODO: write more instructions

To build the test environment: (Starts both ceph-demo and s3-tests containers)
./create-container

To start the test environment:
./start-container

To list all tests in s3-tests run:
```
docker run ceph/s3-tests-image -v --collect-only
```

To run particular tests run docker run with appropriate flags as
mentioned in s3-tests repository.
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
