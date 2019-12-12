# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "triangle"
version = v"0.1.0"

# Collection of sources required to build triangle
sources = [
    "https://github.com/JuliaGeometry/Triangulate.jl.git" =>
    "e7b1237f64ac1ad3b3d205c5b53ad0928b17c631",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd Triangulate.jl/deps/src
$CC -DTRILIBRARY -fPIC -DNDEBUG -DNO_TIMER -DEXTERNAL_TEST $LDFLAGS --shared -o $prefix/libtriangle.so triangle/triangle.c triunsuitable.c

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:i686, libc=:glibc),
    Linux(:x86_64, libc=:glibc),
    Linux(:aarch64, libc=:glibc),
    Linux(:armv7l, libc=:glibc, call_abi=:eabihf),
    Linux(:powerpc64le, libc=:glibc),
    Linux(:i686, libc=:musl),
    Linux(:x86_64, libc=:musl),
    Linux(:aarch64, libc=:musl),
    Linux(:armv7l, libc=:musl, call_abi=:eabihf),
    MacOS(:x86_64),
    FreeBSD(:x86_64),
    Windows(:i686),
    Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libtriangle", :libtriangle)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

