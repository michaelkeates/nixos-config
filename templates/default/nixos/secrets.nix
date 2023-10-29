{ config, pkgs, agenix, secrets, ... }:

let user = "mike"; in
{

  age.identityPaths = [
    "/home/${user}/.ssh/id_ed25519"
  ];

  age.secrets."bitwarden-masterpassword" = {
    symlink = false;
    path = "/home/${user}/.config/Bitwarden/masterpassword";
    file =  "${secrets}/bitwarden-masterpassword.age";
    mode = "600";
    owner = "${user}";
    group = "users";
  };

}
