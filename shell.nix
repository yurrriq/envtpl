{ pkgs ? import ./nix }:

let
  inherit (import ./. { inherit pkgs; }) envtpl;
in

pkgs.mkShell {
  buildInputs = with pkgs; (
    [
      cargo
      go
    ]
  ) ++ (
    with python3Packages; [
      pre-commit
      yamllint
    ]
  );
}
