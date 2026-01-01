{ pkgs, ... }:

{
  # Git configuration
  programs.git = {
    enable = true;
    userName = "ankushKun";
    userEmail = "ankush4singh@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
    };
  };
}
