return {
    COMMAND = {
        DEBIAN = {
            UPDATE = "sudo apt update -y",
            UPGRADE = "sudo apt upgrade -y",
            INSTALL = "sudo apt install -y git liblua5.4-dev screen build-essential libreadline-dev unzip clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev p7zip",
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
    }
}