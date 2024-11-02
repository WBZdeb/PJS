#!/bin/bash

#vars
player_input=-1
board_array=(0 0 0 0 0 0 0 0 0)	# 0 -> empty, 1 -> cross, -1 -> nought

array_sum(){
	tot=0

	for i in ${board_array[@]}; do
		tot+=${i#-}
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
	
	echo -e -n "WELCOME TO TIC-TAC-TOE!\n\n"
	echo -e -n "=======================================\n"
	echo -e -n "PvP - Player VS Player\n"
	echo -e -n "PvE - Player VS Computer\n\n"
	echo -e -n "Exit - Exit game\n"
	echo -e -n "=======================================\n"	
	echo -e -n "Select: "
	
	read player_input
	
	echo -e -n "\n\n You chose: ${player_input}\n"
}

#Draw game board
draw_board(){
	clear
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n"
	echo -e -n "---+---+---\n"
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n"
	echo -e -n "---+---+---\n"
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n"
	echo -e -n "   |   |   \n\n"
}

display_game_legend(){
	
	echo -e -n "=======================================\n"
	echo -e -n "1-9 - Select space\n\n"
	echo -e -n "Exit - Exit game\n"
	echo -e -n "=======================================\n"	
}

#Main block
main(){
	start_game
	main_menu
}
main "$@"