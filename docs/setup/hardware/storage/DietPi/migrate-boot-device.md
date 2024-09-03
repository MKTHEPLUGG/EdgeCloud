# Migrate Boot Device

## Step 1: Prepare to Migrate your install to any Storage Device

1. **Connect the SSD to the Raspberry Pi**:
   - Ensure the SSD is connected to the system that's running the current OS.

2. **Check Disk Configuration**:
   - List all connected storage devices to identify the SSD and SD card:
     ```bash
     lsblk -f
     # or
     sudo fdisk -l
     ```
   - SD cards are typically `/dev/mmcblk0`, and usb devices might be `/dev/sda` or similar. Take note of these device names & fstypes as they will be needed for the next steps.

## Step 2 : Partition and Format your Storage Device

1. **Partition the SSD**:
   - Open the `fdisk` tool to create two partitions on the SSD: one for `/boot` and one for `/`.
     ```bash
     sudo fdisk /dev/sda
     ```
     Replace `/dev/sda` with your Storage Device's device path.
   - In `fdisk`, perform the following:
     - Press `n` to create a new partition.
     - Choose `p` for a primary partition.
     - For the first partition (which will be `/boot`):
       - Choose the default partition number (1).
       - Set the first sector to the default.
       - For the last sector, specify `+200M` to create a 200MB partition for `/boot`.
     - Press `n` again to create the second partition (which will be `/`):
       - Choose the default partition number (2).
       - Set the first sector to the default (which follows immediately after the `/boot` partition).
       - Accept the default for the last sector to use the remaining space for the root filesystem.
     - Press `w` to write the changes and exit `fdisk`.

2. **Format the Partitions**:
   - **Remark**: When you have only one partition format it as ext4
   - Format the first partition (`/dev/sda1`) as FAT32 for the `/boot` partition:
     ```bash
     sudo mkfs.vfat /dev/sda1
     ```
   - Format the second partition (`/dev/sda2`) as ext4 for the root (`/`) partition:
     ```bash
     sudo mkfs.ext4 /dev/sda2
     ```
   - to repair use
     ````shell
     sudo e2fsck -f /dev/sda1 
     ````
## Step 3: Copy the Operating System to the new storage device

1. **Mount the SSD Partitions**:
   - Create mount points for the SSD partitions and mount them:
     ```bash
     sudo mkdir /mnt/ssd_root
     sudo mkdir /mnt/ssd_boot
     sudo mount /dev/sda2 /mnt/ssd_root
     sudo mount /dev/sda1 /mnt/ssd_boot
     
     # to unmount
     umount -l /mnt/ssd_root
     ```

2. **Copy the File System**:
   - Use the `rsync` command to copy the entire file system from the SD card to the SSD:
     ```bash
     sudo rsync -axv --progress / /mnt/ssd_root
     ```
   - Copy the contents of the `/boot` partition to the SSD’s `/boot` partition:
     ```bash
     sudo rsync -av --progress /boot/ /mnt/ssd_boot
     ```

---

