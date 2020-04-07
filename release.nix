{ buildGoModule, nix-gitignore }:

buildGoModule {
  pname = "envtpl";
  version = builtins.readFile ./VERSION;
  src = nix-gitignore.gitignoreSource [] ./.;
  subPackages = [ "cmd/envtpl" ];
  # buildFlagsArray = [
  #   "-ldflags=-X main.AppVersionMetadata=$$(date -u +%s)"
  # ];
  goPackagePath = "github.com/yurrriq/envtpl";
  modSha256 = "0pbabpqzxnnp0kr4imz4hwl6fwv2i0qblymfcrfm58y0xcrbrczr";
}
