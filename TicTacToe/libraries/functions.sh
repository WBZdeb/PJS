# functions.sh
#!/bin/bash

#Sum of elements in board_array
array_sum(){
	tot=0

	for i in ${board_array[@]}; do
		tot=$((${i#-} + $tot))
	done
	echo $tot
}

#Absolute value
abs() {
    if [ "$1" -lt 0 ]; then
        echo "$(( -1 * $1 ))"
    else
        echo "$1"
    fi
}