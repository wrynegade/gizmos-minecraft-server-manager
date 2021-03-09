#!/bin/zsh

alias mserver="MINECRAFT_SERVER"
MINECRAFT_SERVER() {
	case $1 in;
		start | status | stop | restart | enable | disable )
			systemctl --user $1 MinecraftServer.service
			;;
		shutdown-with-warning )
			MINECRAFT_SHUTDOWN_WITH_WARNING
			;;
		monitor )
			while true; do clear; systemctl --user status MinecraftServer.service; sleep 1; done
			;;
		connect )
			MINECRAFT_RCON ${@:2}
			;;
		say )
			MINECRAFT_RCON admin-say ${@:2}
			;;
		save )
			MINECRAFT_SAVE_SERVER
			;;
	esac
}
_MINECRAFT_SERVER() {
	local state;

	_arguments \
		'1: :->commands'\
		':: :->args'\
		;
	case "$state" in
		commands)
			compadd start status stop restart enable disable monitor shutdown-with-warning connect save
			;;
		args)
			[ $words[2] == 'connect' ] && _MINECRAFT_RCON;
			;;
	esac
}
compdef _MINECRAFT_SERVER MINECRAFT_SERVER;

MINECRAFT_RCON() {
	local SYSTEM_TOKEN='[SYSTEM] : '
	local SYSTEM_COLOR='#AAAA00'

	local ADMIN_TOKEN='[ADMIN] : '
	local ADMIN_COLOR='#014D4E'

	local PASS="$MC_RCON_PASSWORD"
	local HOST="$MC_RCON_HOST"
	local PORT="$MC_RCON_PORT"

	[ ! $PASS ] && { echo '\033[31mPlease set $MC_RCON_PASSWORD\033[0m'; return 1 }
	[ ! $HOST ] && HOST='127.0.0.1'
	[ ! $PORT ] && PORT='25575'

	local ARGS;

	case $1 in;
		admin-say )
			OUTPUT_JSON="{\"text\":\"$ADMIN_TOKEN${@:2}\",\"color\":\"$ADMIN_COLOR\"}"
			ARGS="tellraw @a $OUTPUT_JSON" ;; 
		say )
			OUTPUT_JSON="{\"text\":\"$SYSTEM_TOKEN${@:2}\",\"color\":\"$SYSTEM_COLOR\"}"
			ARGS="tellraw @a $OUTPUT_JSON" ;; 
		* )
			ARGS="${@:1}" ;;
	esac

	echo $ARGS

	MCRCON_PASS="$RCON_PASS" MRCON_HOST="$RCON_HOST" MCRCON_PORT="$RCON_PORT" mcrcon "$ARGS"
}
_MINECRAFT_RCON() {
	compadd say kick op deop give shutdown-warn save-all stop
}
compdef _MINECRAFT_RCON MINECRAFT_RCON;

MINECRAFT_SAVE_SERVER() {
	MINECRAFT_RCON say 'saving server state...'
	MINECRAFT_RCON save-all
	MINECRAFT_RCON say 'server state saved!'
}

MINECRAFT_SHUTDOWN_WITH_WARNING() {
	MINECRAFT_RCON say 'server shutdown in 60sec'; echo 'server shutdown in 60sec'; sleep 30;
	MINECRAFT_RCON say 'server shutdown in 30sec'; echo 'server shutdown in 30sec'; sleep 20;
	MINECRAFT_RCON say 'server shutdown in 10sec'; echo 'server shutdown in 10sec'; sleep 5;
	MINECRAFT_RCON say 'server shutdown in 5 sec'; echo 'server shutdown in 5 sec'; sleep 1;
	MINECRAFT_RCON say 'server shutdown in 4 sec'; echo 'server shutdown in 4 sec'; sleep 1;
	MINECRAFT_RCON say 'server shutdown in 3 sec'; echo 'server shutdown in 3 sec'; sleep 1;
	MINECRAFT_RCON say 'server shutdown in 2 sec'; echo 'server shutdown in 2 sec'; sleep 1;
	MINECRAFT_RCON say 'server shutdown in 1 sec'; echo 'server shutdown in 1 sec'; sleep 1;
	MINECRAFT_SERVER stop \
		&& echo 'server successfully shut down' \
		|| echo 'server failed to shut down' ;
}
