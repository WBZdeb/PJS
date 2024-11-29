# menu.sh
#!/bin/bash

#Display main menu; handle functionality
main_menu(){
	clear
	
	echo -e "WELCOME TO TIC-TAC-TOE!\n"
	echo -e "======================================="
	echo -e "(1) Player - Play against a computer"
	echo -e "(2) Players - Play with a friend!\n"
	echo -e "(E)xit - Exit game"
	echo -e "======================================="	
	echo -e -n "Select: "
	echo -e -n "\033[s"
}

#Read and process user selection in menu
read_menu_input(){
	echo -en "\033[s"
	read player_input
	local result=
	
	if [[ "$player_input" =~ ^[0-9]+$ ]] && [ "$player_input" -gt 0 ] && [ "$player_input" -lt 3 ]; then
		#Start single player game
		result="pve"
	elif [[ "${player_input,,}" == "e" ]] || [[ "${player_input,,}" == "exit" ]]; then
		#Close the game
		result="exit_game"
	else
		#Wrong input
		clear_input
		result="pass"
	fi
	
	state=$result
}