#!/bin/bash
# CARDbuyers Masternode Setup Script V1.6 for Ubuntu 16.04 LTS
#
# Script will attempt to auto detect primary public IP address
# and generate masternode private key unless specified in command line
#
# Usage:
# bash node-setup.sh 
#

#Color codes
RED='\033[0;91m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

#Delay script execution for N seconds
function delay { echo -e "${GREEN}Sleep for $1 seconds...${NC}"; sleep "$1"; }



#Function detect_ubuntu

 if [[ $(lsb_release -d) == *16.04* ]]; then
   UBUNTU_VERSION=16
else
   echo -e "${RED}You are not running Ubuntu 16.04, Installation is cancelled.${NC}"
   exit 1


fi

#Check Deps
if [ -d "/var/lib/fail2ban/" ]; 
then
    echo -e "${GREEN}Dependencies already installed...${NC}"
else
    echo -e "${GREEN}Updating system and installing required packages...${NC}"

sudo DEBIAN_FRONTEND=noninteractive apt-get update -y
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:bitcoin/bitcoin -y
sudo apt-get -y update
sudo apt-get -y install wget nano htop jq
sudo apt-get -y install libboost-system-dev libboost-chrono-dev libboost-program-options-dev libboost-test-dev libboost-thread-dev
sudo apt-get -y install libevent-dev
sudo apt-get -y install unzip
sudo apt-get -y install libdb4.8-dev libdb4.8++-dev 
sudo apt-get -y install fail2ban
sudo service fail2ban restart
sudo apt-get -y install libdb5.3++-dev libdb++-dev libdb5.3-dev libdb-dev && ldconfig
sudo apt-get -y install libzmq3-dev libzmq5 build-essential libssl-dev libqrencode-dev libminiupnpc-dev libboost-system1.58.0 libboost1.58-all-dev libdb4.8++ libdb4.8 libevent-pthreads-2.0-5
sudo apt-get -y install make libtool autoconf libboost-dev  libgmp3-dev ufw pkg-config libboost-filesystem-dev libboost-all-dev
   fi


#Create 2GB swap file
#if grep -q "SwapTotal" /proc/meminfo; then
if grep -q "swapfile" /etc/fstab; then
    echo -e "${GREEN}Skipping disk swap configuration...${NC} \n"
else
    echo -e "${YELLOW}Creating 2GB disk swap file. \nThis may take a few minutes!${NC} \a"
    touch /var/swap.img
    chmod 600 /var/swap.img
    dd if=/dev/zero of=/var/swap.img bs=1024k count=2000
    mkswap /var/swap.img 2> /dev/null
    swapon /var/swap.img 2> /dev/null
    if [ $? -eq 0 ]; then
        echo '/var/swap.img none swap sw 0 0' >> /etc/fstab
        echo -e "${GREEN}Swap was created successfully!${NC} \n"
    else
        echo -e "${RED}Operation not permitted! Optional swap was not created.${NC} \a"
        rm /var/swap.img
    fi
fi

# EOF