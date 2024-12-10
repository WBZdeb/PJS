# game.sh
#!/bin/bash

#Perform game setup
start_game(){
	placement_array=("\033[3;3H" "\033[3;7H" "\033[3;11H" "\033[7;3H" "\033[7;7H" "\033[7;11H" "\033[11;3H" "\033[11;7H" "\033[11;11H")
	board_array=(0 0 0 0 0 0 0 0 0)
	turn=1
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

#Display legend for inputs while in game
display_game_legend(){
	#local max=$((9 - $(array_sum)))
	echo -e "======================================="
	echo -e "1-9 - Select space\n"
	echo -e "(E)xit - Exit to menu"
	echo -e "======================================="
	echo -e -n "Select: "
	echo -e -n "\033[s"	
}

#Read and process user selection during game
read_game_input(){
	echo -en "\033[s"
	read player_input
	local max=$((10 - $(array_sum)))
	local result=
	
	if [[ "$player_input" =~ ^[1-9]+$ ]] && [ "${board_array[$((player_input-1))]}" -eq 0 ]; then
		#Draw symbol in correct spot, resume game
		draw_symbol $((player_input - 1))
		turn=$(( -turn ))
		result="selection"
		
		#Check victory conditions
		check_for_victory $((player_input - 1))
		
	elif [[ "${player_input,,}" == "e" ]] || [[ "${player_input,,}" == "exit" ]]; then
		#Go back to main menu
		result="menu"
	else
		#Wrong input
		result="pass"
	fi
	
	state=$result
}

#Draw a symbol on game board
draw_symbol(){
	echo -en "${placement_array[$1]}"
	
	if [ "$turn" -eq 1 ]; then
		echo -n "X"
	elif [ "$turn" -eq -1 ]; then
		echo -n "O"
	fi
	
	echo -en "\033[u"
	
	#modify value in board_array
	board_array[$1]=$(($turn))
}

draw_strikethrough(){
	#Drawing
	case $1 in
		0)
			if [[ "$2" -eq 1 ]]; then
				echo -en "\033[3;2H-\033[3;4H-\033[3;6H-\033[3;8H-\033[3;10H-\033[3;12H-"
			elif [[ "$2" -eq 3 ]]; then
				echo -en "\033[2;3H|\033[4;3H|\033[6;3H|\033[8;3H|\033[10;3H|\033[12;3H|"
			elif [[ "$2" -eq 4 ]]; then
				echo -en "\033[2;2H\\"
				echo -en "\033[4;4H\\"
				echo -en "\033[6;6H\\"
				echo -en "\033[8;8H\\"
				echo -en "\033[10;10H\\"
				echo -en "\033[12;12H\\"
			fi
			;;
		1)
			echo -en "\033[7;2H-\033[7;4H-\033[7;6H-\033[7;8H-\033[7;10H-\033[7;12H-"
			;;
		2)
			if [[ "$2" -eq 4 ]]; then
				echo -en "\033[12;2H/\033[10;4H/\033[8;6H/\033[6;8H/\033[4;10H/\033[2;12H/"
			elif [[ "$2" -eq 5 ]]; then
				echo -en "\033[2;11H|\033[4;11H|\033[6;11H|\033[8;11H|\033[10;11H|\033[12;11H|"
			fi
			;;
		3)
			echo -en "\033[7;2H-\033[7;4H-\033[7;6H-\033[7;8H-\033[7;10H-\033[7;12H-"
			;;
		6)
			echo -en "\033[11;2H-\033[11;4H-\033[11;6H-\033[11;8H-\033[11;10H-\033[11;12H-"
			;;
		*)
			;;
	esac
	echo -en "\033[u"
}

#Clear player input after selection
clear_input(){
	echo -en "\033[u"
	echo -en "\033[K"
	echo -en "\033[u"
}

#Check victory conditions
check_for_victory(){
	local win=0
	
	#Check rows for victory
	case $1 in
		0|1|2)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[0] + board_array[1] + board_array[2])))" -eq 3 ]; then
					win=$(((board_array[0] + board_array[1] + board_array[2]) / 3))
					# Draw the strikethrough
					draw_strikethrough 0 1
				fi
			fi
			;;&
		3|4|5)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[3] + board_array[4] + board_array[5])))" -eq 3 ]; then
					win=$(((board_array[3] + board_array[4] + board_array[5]) / 3))
					# Draw the strikethrough
					draw_strikethrough 3
				fi
			fi
			;;&
		6|7|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[6] + board_array[7] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[6] + board_array[7] + board_array[8]) / 3))
					# Draw the strikethrough
					draw_strikethrough 6
				fi
			fi
			;;&
		0|3|6)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[0] + board_array[3] + board_array[6])))" -eq 3 ]; then
					win=$(((board_array[0] + board_array[3] + board_array[6]) / 3))
					# Draw the strikethrough
					draw_strikethrough 0 3
				fi
			fi
			;;&
		1|4|7)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[1] + board_array[4] + board_array[7])))" -eq 3 ]; then
					win=$(((board_array[1] + board_array[4] + board_array[7]) / 3))
					# Draw the strikethrough
					draw_strikethrough 1
				fi
			fi
			;;&
		2|5|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[2] + board_array[5] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[2] + board_array[5] + board_array[8]) / 3))
					# Draw the strikethrough
					draw_strikethrough 2 5
				fi
			fi
			;;&
		0|4|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[0] + board_array[4] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[0] + board_array[4] + board_array[8]) / 3))
					# Draw the strikethrough
					draw_strikethrough 0 4
				fi
			fi
			;;&
		2|4|6)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[2] + board_array[4] + board_array[6])))" -eq 3 ]; then
					win=$(((board_array[2] + board_array[4] + board_array[6]) / 3))
					# Draw the strikethrough
					draw_strikethrough 2 4
				fi
			fi
			;;&
		*)
			;;
	esac
	
	#If player won, change state
	if [ "$win" -eq 1 ]; then
		result="victoryCross"
	elif [ "$win" -eq -1 ]; then
		result="victoryNought"
	fi
}