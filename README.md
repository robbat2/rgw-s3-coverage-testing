TODO: write more instructions

To build the test environment:
./create-container

To start the test environment:
./start-container

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
