#!/bin/bash

#vars
player_input=-1

#Perform game setup
start_game(){
	:
}

#Display main menu; handle functionality
main_menu(){
	clear
	
	
	echo -e -n "=======================================\n"
	echo -e -n "WELCOME TO TIC-TAC-TOE!\n\n"
	echo -e -n "1 - Player VS Player\n"
	echo -e -n "2 - Player VS Computer\n\n"
	echo -e -n "0 - Exit game\n"
	echo -e -n "=======================================\n"	
	echo -e -n "Choose you game mode: "
	
	read player_input
	
	echo -e -n "\n\n You chose: ${player_input}\n"
}


start_game
main_menu
