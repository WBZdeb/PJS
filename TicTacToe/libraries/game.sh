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
	local max=$((9 - $(array_sum)))
	echo -e "======================================="
	echo -e "1-${max} - Select space\n"
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
	
	if [[ "$player_input" =~ ^[0-9]+$ ]] && [ "$player_input" -gt 0 ] && [ "$player_input" -lt "$max" ]; then
		#Draw symbol in correct spot, resume game
		draw_symbol $((player_input - 1))
		unset "placement_array[$((player_input - 1))]"
		placement_array=( "${placement_array[@]}" )
		turn=$(( -turn ))
		result="selection"
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
					win=$(((board_array[0] + board_array[1] + board_array[2])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		3|4|5)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[3] + board_array[4] + board_array[5])))" -eq 3 ]; then
					win=$(((board_array[3] + board_array[4] + board_array[5])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		6|7|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[6] + board_array[7] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[6] + board_array[7] + board_array[8])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		0|3|6)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[0] + board_array[3] + board_array[6])))" -eq 3 ]; then
					win=$(((board_array[0] + board_array[3] + board_array[6])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		1|4|7)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[1] + board_array[4] + board_array[7])))" -eq 3 ]; then
					win=$(((board_array[1] + board_array[4] + board_array[7])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		2|5|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[2] + board_array[5] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[2] + board_array[5] + board_array[8])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		0|4|8)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[0] + board_array[4] + board_array[8])))" -eq 3 ]; then
					win=$(((board_array[0] + board_array[4] + board_array[8])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		2|4|6)
			if [ "$win" -eq 0 ]; then
				if [ "$(abs $((board_array[2] + board_array[4] + board_array[6])))" -eq 3 ]; then
					win=$(((board_array[2] + board_array[4] + board_array[6])) / 3)
					# Draw the strikethrough
				fi
			fi
			;;&
		*)
			;;
	esac
	
	#If player won, change state
	if [ "$win" -eq 1 ]; then
		state="victoryCross"
	elif [ "$win" -eq -1 ]; then
		state="victoryNought"
	fi
}