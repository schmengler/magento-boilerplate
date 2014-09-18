#!/bin/sh
start_rsync_auto() {
	echo -e "\x1b[34m\x1b[1mRsync shared folders...\x1b[0m"
	vagrant rsync-auto &
	echo -e "\x1b[34m\x1b[1mNow running rsync in the background (pid=\x1b[32m$!\x1b[34m).\x1b[0m"
}
kill_rsync_auto() {
    echo -e "\x1b[34m\x1b[1mKill rsync-auto process...\x1b[0m"
    kill -INT $!
}

echo -e "\x1b[34m\x1b[1mStarting Vagrantbox...\x1b[0m"
vagrant up || exit
start_rsync_auto;

while true; do
	echo -e "\x1b[32m[L]\x1b[33m Login via SSH"
	echo -e "\x1b[32m[H]\x1b[33m Halt"
	echo -e "\x1b[32m[S]\x1b[33m Suspend"
	echo -e "\x1b[32m[R]\x1b[33m Restart rsnyc-auto watcher"
	echo -e "\x1b[32m[P]\x1b[33m Provision\x1b[0m"
    read -p "> " cmd
    case $cmd in
        [Hh]* ) kill_rsync_auto; echo -e "\x1b[34m\x1b[1mHalt Vagrantbox...\x1b[0m"; vagrant halt; break;;
        [Ss]* ) kill_rsync_auto; echo -e "\x1b[34m\x1b[1mSuspend Vagrantbox...\x1b[0m"; vagrant suspend; break;;
        [Ll]* ) echo -e "\x1b[34m\x1b[1mConnecting to Vagrantbox...\x1b[0m"; vagrant ssh; continue;;
		[Rr]* ) kill_rsync_auto; echo -e "\x1b[34m\x1b[1mRestart rsync-auto...\x1b[0m"; start_rsync_auto; continue;;
		[Pp]* ) echo -e "\x1b[34m\x1b[1mProvisioning...\x1b[0m"; vagrant provision; continue;;
        * ) [ "$cmd" != "" ] && echo -e "\x1b[31mNot recognized command '$cmd'.\x1b[0m";;
    esac
done

echo -e "\x1b[33mVagrantbox stopped.\x1b[0m"