{ ... }: {
# This formats the disk with the ext4 filesystem
# Other examples found here: https://github.com/nix-community/disko/tree/master/example
 disko.devices = {
  disk = {
   vdb = {
    device = builtins.elemAt disks 0;
    type = "disk";
    content = {
     type = "gpt";
     partitions = {
      ESP = {
       size = "500M";
       content = {
        type = "filesystem";
        format = "vfat";
        mountpoint = "/boot";
       };
      };
      root = {
       size = "100%";
       content = {
        type = "filesystem";
        format = "ext4";
        mountpoint = "/";
       };
      };
     };
    };
   };
  };
 };
}