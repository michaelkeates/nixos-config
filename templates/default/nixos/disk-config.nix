{ ... }: {
# This formats the disk with the ext4 filesystem
# Other examples found here: https://github.com/nix-community/disko/tree/master/example
    disko.devices = {
        disk = {
            vda = {
                #device = "/dev/disk/by-id/some-disk-id";
                device = "/dev/vda";
                type = "disk";
                content = {
                    type = "gpt";
                    partitions = {
                        ESP = {
                            type = "EF00";
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
  };
}