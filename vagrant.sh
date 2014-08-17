#!/bin/sh
echo Starting Vagrantbox...
vagrant up
echo Rsync shared folders...
vagrant rsync-auto > var/log/rsync.log 2> var/log/rsync_error.log &
echo "Now running rsync in the background (pid=$!)."
echo Output is logged to var/log/rsync.log

kill_rsync_auto() {
    echo "Kill rsync-auto processes..."
    kill -INT $!
    # also kill windows processes, workaround from https://github.com/mitchellh/vagrant/issues/3824
    WMIC path win32_process get Processid,Commandline | grep rsync-auto | awk '{print $NF}' | xargs -n 1 taskkill /f /pid
}

while true; do
    read -p "Press H to halt the virtual machine, S to suspend, L to login via SSH: " hs
    case $hs in
        [Hh]* ) kill_rsync_auto; echo "Halt Vagrantbox..."; vagrant halt; break;;
        [Ss]* ) kill_rsync_auto; echo "Suspend Vagrantbox..."; vagrant suspend; break;;
        [Ll]* ) echo "Connecting to Vagrantbox..."; vagrant ssh; continue;;
        * ) echo "Not recognized command $hs.";;
    esac
done

echo Vagrantbox stopped.