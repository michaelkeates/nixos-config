{ ... }: {
  disko.devices = {
    disk = {
      nvda = {  # Change "nvme0n1" to "nvda"
        device = "/dev/nvda";  # Change "/dev/nvme0n1" to "/dev/nvda"
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "600M";  # Change size to 600M
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              start = "600M";  # Start at 600M
              size = "100%";   # Takes the remaining space
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