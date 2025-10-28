#!/bin/bash

#This is the array for the random objects
RandomItems=("Dresser" "Jar" "Chocolate bar" "Sofa" "Apple tree" "Shawl" "Butterfly" "Underwear" "Coat rack" "Hair dryer") 

#saves the file to the /data directory
save_file() {
  read -p "Enter the name of your save file" filename

}



#shows the full list of objects
print_list() {
  echo "Here is the list:"
  for i in "${!RandomItems[@]}"; do
    echo "$i: ${RandomItems[$i]}"
  done
}

#shows one object by its number
print_item() {
  echo "Here are all the current number of items ${#RandomItems[@]}, starting from 0"
  sleep 2
  read -p "Enter the number of the item: " number
  if [[ $number -ge 0 && $number -lt ${#RandomItems[@]} ]]; then
    echo "Item $number is ${RandomItems[$number]}"
  else
    echo "That number doesn’t exist."
  fi
}

# add a new item
add_item() {
  read -p "Enter something to add: " thing
  RandomItems+=("$thing")
  echo "$thing added to the list."
}

# remove the last item
remove_last() {
  unset 'RandomItems[-1]'
  echo "Last item removed."
}

# remove an item by its number
remove_item() {
  echo "Here are all the current number of items ${#RandomItems[@]}, Starting from 0"
  read -p "Enter the number of the item to remove: " num
  if [[ $num -ge 0 && $num -lt ${#RandomItems[@]} ]]; then
    echo "${RandomItems[$num]} was removed."
    unset 'RandomItems[num]'
    RandomItems=("${RandomItems[@]}")
  else
    echo "That number doesn’t exist."
  fi
}



while true; do
  sleep 3
  echo "BASHING BOXES MENU"
  echo "1. Print list"
  echo "2. Print one item"
  echo "3. Add new item"
  echo "4. Remove last item"
  echo "5. Remove item by number"
  echo "6. "
  echo "7. "
  echo "8. "
  echo "9. "
  echo "10. Exit"
  read -p "Pick an option (1-10): " choice


  case $choice in 
    1) print_list ;;
    2) print_item ;;
    3) add_item ;;
    4) remove_last ;;
    5) remove_item ;;
    6) delete_save;;
    7) save_file;;
    8) load_file;;
    9) list_saves;;
    10) echo "Bye"; exit ;;
    *) echo "Not a valid choice." ;;
  esac
done