return {
    COMMAND = {
        DEBIAN = {
            UPDATE = "sudo apt update -y",
            UPGRADE = "sudo apt upgrade -y",
            INSTALL = "sudo apt install -y ",
        },

        FEDORA = {
            UPDATE = "sudo dnf update -y",
            UPGRADE = "sudo dnf upgrade -y",
            INSTALL = "sudo dnf install -y ",
        },

        LINUX = {
            SUBMODULE = "git submodule update --init",
            BUILD_LUAROCKS = "rm -rf build && mkdir build && ./configure --prefix=\"./build\" && make ${nproc} install",
            SYM_LINK_LUAROCKS = "ln -s core/vendor/luarocks/build/bin/luarocks luarocks",
            INSTALL_MOONSCRIPT = "./luarocks install moonscript"
        },

        UNIVERSAL = {
            CD = "cd %s",
        }
    },

    PACKAGE = {
        DEBIAN = {
            "clang",
            "cmake",
            "make",
            "gcc",
            "g++",
            "libmysqlclient-dev",
            "libssl-dev",
            "libbz2-dev",
            "libreadline-dev",
            "libncurses-dev",
            "libboost-all-dev",
            "mysql-server",
            "p7zip",
        },

        FEDORA = {
            "clang",
            "cmake",
            "make",
            "gcc",
            "gcc-c++",
            "community-mysql-devel",
            "openssl-devel",
            "bzip2-devel",
            "readline-devel",
            "ncurses-devel",
            "boost-devel",
            "community-mysql-server",
            "p7zip"
        }
    }
}