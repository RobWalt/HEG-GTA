{ pkgs, comfy, ... }:
comfy.overrideAttrs (final: prev: {
  shellHook = '' 
  echo hi
  '';
})
