# LVM

LVM���߼��̾����Logical Volume Manager���ļ�ƣ�����Linux�����¶Դ��̷������й����һ�ֻ��ƣ�LVM�ǽ�����Ӳ�̺ͷ���֮�ϵ�һ���߼��㣬����ߴ��̷������������ԡ�LVM���ڴ��̷������ļ�ϵͳ֮����ӵ�һ���߼��㣬��Ϊ�ļ�ϵͳ�����²���̷������֣��ṩһ��������̾����̾��Ͻ����ļ�ϵͳ�������physical volume����������ָӲ�̷�������߼�������̷�������ͬ�����ܵ��豸����RAID������LVM�Ļ����洢�߼��飬���ͻ���������洢���ʣ�����������̵ȣ��Ƚϣ�ȴ��������LVM��صĹ��������

���ƣ�
- �ܹ��������ݵ�ǰ�ķ���������

# LVM operations

![LVM Concepts](images/lv-pv.jpg)

## Prepare the separated disk or physical partitions
```
# fdisk -l

Disk /dev/sda: 43.1 GB, 43055710208 bytes, 84093184 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x0008ee49

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     1026047      512000   83  Linux
/dev/sda2         1026048    84092927    41533440   8e  Linux LVM

Disk /dev/mapper/centos-root: 38.3 GB, 38319161344 bytes, 74842112 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 4160 MB, 4160749568 bytes, 8126464 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 4294 MB, 4294967296 bytes, 8388608 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
```

## Create physical volume
�����Physical Volumes�����PV�����ڴ��̵��������������̷�������ͬ�����ܵ��豸����RAID)�ϴ�����������ֻ������������л�����һ��������������ڼ�����LVM��صĹ��������
�����Physical Volume�����PV��һ�������ֻ������һ����LVM����������������������洢���ʡ�Ҫʹ��LVMϵͳ�����ȶ�Ҫ����LVM�Ĵ��̽��г�ʼ������ʼ����Ŀ�ľ��ǽ����̻������ʶΪLVM �������ʹ��pvcreate ������Խ�һ�����̱��Ϊ LVM ����� 
```
# pvcreate /dev/sdb 
  Physical volume "/dev/sdb" successfully created
# pvdisplay /dev/sdb
  "/dev/sdb" is a new physical volume of "4.00 GiB"
  --- NEW Physical volume ---
  PV Name               /dev/sdb
  VG Name               
  PV Size               4.00 GiB
  Allocatable           NO
  PE Size               0   
  Total PE              0
  Free PE               0
  Allocated PE          0
  PV UUID               dHkPFm-RrAY-G7ak-BDox-AZrU-AfSj-i4UGzO
```

## Create volume group

���飨Volume Group�����VG������һ�����߶����������ϡ����齫�������������һ���γ�һ���ɹ���ĵ�Ԫ���������ڷ�LVMϵͳ�е�����Ӳ�̡� 
������������ϳ�һ�������ʱ��LVM�������е�������������Ƹ�ʽ���Ĺ�������ÿ��������г�һ��һ��Ŀռ䣬��һ��һ��Ŀռ�ͳ�ΪPE��Physical Extent ��������Ĭ�ϴ�С��4MB�� 
�������ں����Ƶ�ԭ��һ���߼���Logic Volume�����ֻ�ܰ���65536��PE��Physical Extent��������һ��PE�Ĵ�С�;������߼�������������4 MB ��PE�����˵����߼����������Ϊ 256 GB����ϣ��ʹ�ô���256G���߼����򴴽�����ʱ��Ҫָ�������PE����Red Hat Enterprise Linux AS 4��PE��С��ΧΪ8 KB �� 16GB�����ұ������� 2 �ı����� 

���������Physical Extents�����PE��LVM��ÿ�������ֱ������������Ŀ�Ѱַ�洢��Ԫ���洢��Ԫ�Ĵ�Сͨ��Ϊ��MB�����̵Ŀ�ͷ����ΪLVMԪ���ݣ�֮�������Ϊ�㿪ʼ��ÿ������������������ε���һ����˳����з��䡣
```
# vgcreate myvg /dev/sdb
  Volume group "myvg" successfully created
# vgdisplay myvg
  --- Volume group ---
  VG Name               myvg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  1
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                0
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               4.00 GiB
  PE Size               4.00 MiB
  Total PE              1023
  Alloc PE / Size       0 / 0   
  Free  PE / Size       1023 / 4.00 GiB
  VG UUID               j7LufK-yFBa-iwio-67O0-o6aw-odNk-CFsEgG
# pvdisplay /dev/sdb 
  --- Physical volume ---
  PV Name               /dev/sdb
  VG Name               myvg
  PV Size               4.00 GiB / not usable 4.00 MiB
  Allocatable           yes 
  PE Size               4.00 MiB
  Total PE              1023
  Free PE               1023
  Allocated PE          0
  PV UUID               dHkPFm-RrAY-G7ak-BDox-AZrU-AfSj-i4UGzO
```

## Create logic volume

�߼���Logical Volumes�����LV�����ھ����л��ֵ�һ���߼����������ڷ�LVMϵͳ�е�Ӳ�̷�����
ͬ����һ�����߼����ڴ����Ĺ�����Ҳ���ֳ���һ��һ��Ŀռ䣬��Щ�ռ��ΪLE��Logical Extents������ͬһ�������У�LE�Ĵ�С��PE����ͬ�ģ�����һһ��Ӧ��
```
# lvcreate -L 100M -n mylv1 myvg
  Logical volume "mylv1" created.
# lvs
  LV    VG     Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root  centos -wi-ao----  35.69g                                                    
  swap  centos -wi-ao----   3.88g                                                    
  mylv1 myvg   -wi-a----- 100.00m
# lvdisplay myvg
  --- Logical volume ---
  LV Path                /dev/myvg/mylv1
  LV Name                mylv1
  VG Name                myvg
  LV UUID                WMe0rF-7inv-OcvN-AWGH-pQzP-q5HT-CGfqFl
  LV Write Access        read/write
  LV Creation host, time centos7host4.wyq.com, 2016-12-25 07:41:15 -0500
  LV Status              available
  # open                 0
  LV Size                100.00 MiB
  Current LE             25
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2                                               
```

## Create file system
```
# mkfs -t ext3 /dev/myvg/mylv1
mke2fs 1.42.9 (28-Dec-2013)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
Stride=0 blocks, Stripe width=0 blocks
25688 inodes, 102400 blocks
5120 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67371008
13 block groups
8192 blocks per group, 8192 fragments per group
1976 inodes per group
Superblock backups stored on blocks: 
	8193, 24577, 40961, 57345, 73729

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (4096 blocks): done
Writing superblocks and filesystem accounting information: done 

# mkdir /opt/mylv1
# mount /dev/myvg/mylv1 /opt/mylv1/

Ϊ����ϵͳ����ʱ�Զ������ļ�ϵͳ������Ҫ��/etc/fstab���������: 
/dev/myvg/mylv1 /opt/mylv1 ext3 defaults 1 2 
```

LVM�����ô����ǿ��Զ�̬�ص���������С����������������������

## Extend the logical volume
```
# vgdisplay myvg
  --- Volume group ---
  VG Name               myvg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               4.00 GiB
  PE Size               4.00 MiB
  Total PE              1023
  Alloc PE / Size       25 / 100.00 MiB
  Free  PE / Size       998 / 3.90 GiB
  VG UUID               j7LufK-yFBa-iwio-67O0-o6aw-odNk-CFsEgG

ȷ����ǰ����ʣ��ռ�3.90 GiB��ʣ��PE����Ϊ998��������������25��PE���߼���/dev/myvg/mylv1��

# lvextend -l+25 /dev/myvg/mylv1 
  Size of logical volume myvg/mylv1 changed from 100.00 MiB (25 extents) to 200.00 MiB (50 extents).
  Logical volume mylv1 successfully resized.
# lvdisplay myvg
  --- Logical volume ---
  LV Path                /dev/myvg/mylv1
  LV Name                mylv1
  VG Name                myvg
  LV UUID                WMe0rF-7inv-OcvN-AWGH-pQzP-q5HT-CGfqFl
  LV Write Access        read/write
  LV Creation host, time centos7host4.wyq.com, 2016-12-25 07:41:15 -0500
  LV Status              available
  # open                 1
  LV Size                200.00 MiB
  Current LE             50
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     8192
  Block device           253:2

# df -TH
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        39G  1.4G   38G   4% /
devtmpfs                devtmpfs  2.0G     0  2.0G   0% /dev
tmpfs                   tmpfs     2.0G     0  2.0G   0% /dev/shm
tmpfs                   tmpfs     2.0G  8.8M  2.0G   1% /run
tmpfs                   tmpfs     2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/sda1               xfs       521M  174M  348M  34% /boot
tmpfs                   tmpfs     398M     0  398M   0% /run/user/0
/dev/mapper/myvg-mylv1  ext3       98M  1.7M   91M   2% /opt/mylv1

# resize2fs /dev/mapper/myvg-mylv1
resize2fs 1.42.9 (28-Dec-2013)
Filesystem at /dev/mapper/myvg-mylv1 is mounted on /opt/mylv1; on-line resizing required
old_desc_blocks = 1, new_desc_blocks = 1
The filesystem on /dev/mapper/myvg-mylv1 is now 204800 blocks long.

[root@centos7host4 mylv1]# df -TH
Filesystem              Type      Size  Used Avail Use% Mounted on
/dev/mapper/centos-root xfs        39G  1.4G   38G   4% /
devtmpfs                devtmpfs  2.0G     0  2.0G   0% /dev
tmpfs                   tmpfs     2.0G     0  2.0G   0% /dev/shm
tmpfs                   tmpfs     2.0G  8.8M  2.0G   1% /run
tmpfs                   tmpfs     2.0G     0  2.0G   0% /sys/fs/cgroup
/dev/sda1               xfs       521M  174M  348M  34% /boot
tmpfs                   tmpfs     398M     0  398M   0% /run/user/0
/dev/mapper/myvg-mylv1  ext3      200M  1.7M  189M   1% /opt/mylv1
```

## Extend the volume group
��������û���㹻�Ŀռ�������չ�߼���Ĵ�Сʱ������Ҫ���Ӿ���������������Ӿ���������Ωһ�취���������������µ��������������������������Ӳ�̻��߷���
```
# vgextend myvg /dev/sdc
```
