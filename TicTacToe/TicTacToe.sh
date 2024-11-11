#!/bin/bash

#vars
state="menu"
old_state="pass"
player_input=-1
turn=0	# 1 -> crosses' turn | -1 -> noughts' turn
board_array=(0 0 0 0 0 0 0 0 0)	# 0 -> empty, 1 -> cross, -1 -> nought
placement_array=("\033[3;3H" "\033[3;7H" "\033[3;11H" "\033[7;3H" "\033[7;7H" "\033[7;11H" "\033[11;3H" "\033[11;7H" "\033[11;11H")

array_sum(){
	tot=0

	for i in ${board_array[@]}; do
		tot=$((${i#-} + $tot))
	done
	echo $tot
}

#Perform game setup
start_game(){
	placement_array=("\033[3;3H" "\033[3;7H" "\033[3;11H" "\033[7;3H" "\033[7;7H" "\033[7;11H" "\033[11;3H" "\033[11;7H" "\033[11;11H")
	board_array=(0 0 0 0 0 0 0 0 0)
	turn=1
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
	echo -e -n "\033[s"
}

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

#Draw game board
draw_board(){
	clear
	echo -e "\n    |   |   "
	echo -e "    |   |   "
	echo -e "    |   |   "
	echo -e " ---+---+---"
	echo -e "    |   |   "
	echo -e "    |   |   "
	echo -e "    |   |   "
	echo -e " ---+---+---"
	echo -e "    |   |   "
	echo -e "    |   |   "
	echo -e "    |   |   \n"
}

display_game_legend(){
	local max=$((9 - $(array_sum)))
	echo -e "======================================="
	echo -e "1-${max} - Select space\n"
	echo -e "(E)xit - Exit to menu"
	echo -e "======================================="
	echo -e -n "Select: "
	echo -e -n "\033[s"	
}

read_game_input(){
	echo -en "\033[s"
	read player_input
	local max=$((10 - $(array_sum)))
	local result=
	
	if [[ "$player_input" =~ ^[0-9]+$ ]] && [ "$player_input" -gt 0 ] && [ "$player_input" -lt "$max" ]; then
		#Draw symbol in correct spot, resume game
		draw_symbol $((player_input - 1))
		unset "placement_array[$((player_input - 1))]"
		placement_array=( "${placement_array[@]}" )
		clear_input
		turn=$(( -turn ))
		result="selection"
	elif [[ "${player_input,,}" == "e" ]] || [[ "${player_input,,}" == "exit" ]]; then
		#Go back to main menu
		result="menu"
	else
		#Wrong input
		clear_input
		result="pass"
	fi
	
	state=$result
}

draw_symbol(){
	echo -en "${placement_array[$1]}"
	
	if [ "$turn" -eq 1 ]; then
		echo -n "X"
	elif [ "$turn" -eq -1 ]; then
		echo -n "O"
	fi
	
	#modify value in board_array
	local count=0 

    for i in "${!board_array[@]}"; do
        if [[ ${board_array[$i]} -eq 0 ]]; then  # Check if the current element is a zero
            if [[ $count -eq $1 ]]; then  # If it's the n-th zero
                board_array[$i]=$(($turn))
                break
            fi
            ((count++))  # Increment the counter if the element is a zero
        fi
    done
}

clear_input(){
	echo -en "\033[u"
	echo -en "\033[K"
	echo -en "\033[u"
}

check_for_victory(){
	:
}

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
				;;
			"selection")
				old_state=$state
				check_for_victory
				read_game_input
				;;
			"pass")
				clear_input
				if [[ "${old_state}" == "menu" ]]; then
					read_menu_input
				else
					read_game_input
				fi
				;;
			*) 
				state=$old_state
				;;
		esac
	done
}
main "$@"