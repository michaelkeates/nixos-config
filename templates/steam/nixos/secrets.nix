{ config, pkgs, agenix, secrets, ... }:

let user = "mike"; in
{

  age.identityPaths = [
    "/home/${user}/.ssh/id_ed25519"
  ];

  age.secrets."secret" = {
    symlink = false;
    path = "/home/${user}/.config/Bitwarden/masterpassword";
    file =  "${secrets}/secret.age";
    mode = "600";
    owner = "${user}";
    group = "users";
  };

}