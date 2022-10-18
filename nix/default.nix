{
  pkgs,
  nimPackages,
  lib,
  ...
}: {
  pname,
  version,
  name ? "${pname}-${version}",
  src,
  nimbleFile,
  nimbleLockFile,
}:
nimPackages.buildNimPackage {
  inherit name src;
}
