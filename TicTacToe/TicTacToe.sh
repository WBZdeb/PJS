# TicTacToe.sh
#!/bin/bash

#Global vars
state="menu"
old_state="pass"
player_input=-1
turn=0	# 1 -> crosses' turn | -1 -> noughts' turn
board_array=(0 0 0 0 0 0 0 0 0)	# 0 -> empty, 1 -> cross, -1 -> nought
placement_array=("\033[3;3H" "\033[3;7H" "\033[3;11H" "\033[7;3H" "\033[7;7H" "\033[7;11H" "\033[11;3H" "\033[11;7H" "\033[11;11H")

#Load library files
source ./libraries/functions.sh
source ./libraries/menu.sh
source ./libraries/game.sh


#Main block
main(){
	echo "" > state.txt
	
	while [[ "${state}" != "exit_game" ]]
	do
		#Case statement for resolving game state
		echo $state >> state.txt
		case "$state" in
			"menu") 
				main_menu
				old_state=$state
				read_menu_input
				;;
			"pve")
				start_game
				draw_board
				display_game_legend
				old_state=$state
				read_game_input
				clear_input
				;;
			"selection")
				old_state=$state
				#update_legend
				check_for_victory
				read_game_input
				clear_input
				;;
			"pass")
				if [[ "${old_state}" == "menu" ]]; then
					read_menu_input
				else
					read_game_input
					clear_input
				fi
				;;
			"victoryCross"|"victoryNought")
				old_state=$state
				#Display correct victory screen
				#read_victory_input
				#clear_input
				;;
			*) 
				state=$old_state
				;;
		esac
	done
}
main "$@"