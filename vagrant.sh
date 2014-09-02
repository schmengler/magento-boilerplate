#!/bin/sh
start_rsync_auto() {
	echo Rsync shared folders...
	vagrant rsync-auto &
	echo "Now running rsync in the background (pid=$!)."
}
kill_rsync_auto() {
    echo "Kill rsync-auto processes..."
    kill -INT $!
}

echo Starting Vagrantbox...
vagrant up
start_rsync_auto;

while true; do
    read -p "Press H to halt the virtual machine, S to suspend, L to login via SSH, R to restart rsync-auto: " hs
    case $hs in
        [Hh]* ) kill_rsync_auto; echo "Halt Vagrantbox..."; vagrant halt; break;;
        [Ss]* ) kill_rsync_auto; echo "Suspend Vagrantbox..."; vagrant suspend; break;;
        [Ll]* ) echo "Connecting to Vagrantbox..."; vagrant ssh; continue;;
		[Rr]* ) kill_rsync_auto; echo "Restart rsync-auto..."; start_rsync_auto; continue;
        * ) echo "Not recognized command $hs.";;
    esac
done

echo Vagrantbox stopped.