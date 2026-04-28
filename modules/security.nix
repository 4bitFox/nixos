
{ config, pkgs, lib, ... }:


{
  ### fix ulimit 'too many open files' during rebuild/compilation of e.g. alpaca ###
  security.pam.loginLimits = [
    { domain = "*"; type = "soft"; item = "nofile"; value = "65536"; }
    { domain = "*"; type = "hard"; item = "nofile"; value = "1048576"; }
  ];
  ### fix ulimit 'too many open files' ###
}
