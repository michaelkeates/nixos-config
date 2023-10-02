{ disks ? [ "/dev/vda" ], ... }: {
 disk = {
  vda = {
   device = builtins.elemAt disks 0;
   type = "disk";
   content = {
    type = "gpt";
    partitions = {
     ESP = {
      size = "100M";
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
}