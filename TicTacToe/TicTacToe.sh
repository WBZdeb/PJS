#!/bin/bash

#vars
player_input=-1
board_array=(0 0 0 0 0 0 0 0 0)	# 0 -> empty, 1 -> cross, -1 -> nought

array_sum(){
	tot=0

	for i in ${board_array[@]}; do
		tot=$((${i#-} + $tot))
	done
	echo $tot
} 

#Perform game setup
start_game(){
	:
}

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
}

read_menu_input(){
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
		result="pass"
	fi
	
	echo $result
}

#Draw game board
draw_board(){
	clear
	echo -e "   |   |   "
	echo -e "   |   |   "
	echo -e "   |   |   "
	echo -e "---+---+---"
	echo -e "   |   |   "
	echo -e "   |   |   "
	echo -e "   |   |   "
	echo -e "---+---+---"
	echo -e "   |   |   "
	echo -e "   |   |   "
	echo -e "   |   |   \n"
}

display_game_legend(){
	local max=$((9 - $(array_sum)))
	echo -e "======================================="
	echo -e "1-${max} - Select space\n"
	echo -e "(E)xit - Exit to menu"
	echo -e "======================================="	
}

read_game_input(){
	read player_input
	local max=$((9 - $(array_sum)))
	local result=
	
	if [[ "$player_input" =~ ^[0-9]+$ ]] && [ "$player_input" -gt 0 ] && [ "$player_input" -le "$max" ]; then
		#Draw symbol in correct spot, resume game
		#draw_symbol "$player_input"
		result="selection"
	elif [[ "${player_input,,}" == "e" ]] || [[ "${player_input,,}" == "exit" ]]; then
		#Go back to main menu
		result="menu"
	else
		#Wrong input
		result="pass"
	fi
	
	echo $result
}

#Main block
main(){
	local state="menu"
	local old_state="pass"
	start_game
	
	while [[ "${state}" != "exit_game" ]]
	do
		#Case statement for resolving game state
		case "$state" in
			"menu") 
				main_menu
				old_state=$state
				state=$(read_menu_input)
				;;
			"pve") 
				draw_board
				display_game_legend
				old_state=$state
				state=$(read_game_input)
				;;
			*) 
				state=$old_state
				;;
		esac
	done
}
main "$@"