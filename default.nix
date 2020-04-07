{ pkgs ? import ./nix }:
let
  envtpl = pkgs.callPackage ./release.nix {};
in
{
  inherit envtpl;
}
