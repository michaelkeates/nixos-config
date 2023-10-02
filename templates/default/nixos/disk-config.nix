{ disks ? [ "/dev/vda" ], ... }: {
 disko.devices = {
  disk = {
   vda = {
    device = disks !! 0;
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