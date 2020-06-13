with import <nixpkgs> {};

stdenv.mkDerivation {
  name = "lawful-awful";
  buildInputs = [

    # The programming language and build tools
    swift

    # This is required for SwiftNIO
    zlib
    binutils glibc gitAndTools.gitFull

    # These are needed for one of Vapor's dependencies
    pkgconfig openssl

  ];

  # I think the stdenv is overriding these variables even within the swift toolchain:
  shellHook = ''
    export CC=clang
    export CXX=clang++
  '';
}
