{ config, pkgs, agenix, secrets, ... }:

let user = "mike"; in
{
  
  age.identityPaths = [ 
    "/Users/${user}/.ssh/id_ed25519"
  ];

  age.secrets."bitwarden-masterpassword" = {
    symlink = false;
    path = "/Users/${user}/.config/Bitwarden/masterpassword";
    file =  "${secrets}/bitwarden-masterpassword.age";
    mode = "600";
    owner = "${user}";
    group = "staff";
  };
}
