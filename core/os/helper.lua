return {
    DEBIAN = {
        COMMAND = "sudo apt update -y && sudo apt upgrade -y && sudo apt install -y %s && git submodule update --init",
        PACKAGES = "git liblua5.4-dev screen build-essential libreadline-dev unzip clang cmake make gcc g++ libmysqlclient-dev libssl-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev p7zip"
    }
}