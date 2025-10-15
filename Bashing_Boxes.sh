#!/bin/bash

#This is the array for the random objects
RandomItems=("Dresser" "Jar" "Chocolate bar" "Sofa" "Apple tree" "Shawl" "Butterfly" "Underwear" "Coat rack" "Hair dryer") 

#shows the full list of objects
print_list() {
  echo "Here is the list:"
  for i in "${!boxes[@]}"; do
    echo "$i: ${boxes[$i]}"
  done
}

#shows one object by its number
print_item() {
  read -p "Enter the number of the item: " number
  if [[ $number -ge 0 && $number -lt ${#boxes[@]} ]]; then
    echo "Item $number is ${boxes[$number]}"
  else
    echo "That number doesn’t exist."
  fi
}

# add a new item
add_item() {
  read -p "Enter something to add: " thing
  boxes+=("$thing")
  echo "$thing added to the list."
}

# remove the last item
remove_last() {
  unset 'boxes[-1]'
  echo "Last item removed."
}

# remove an item by its number
remove_item() {
  read -p "Enter the number of the item to remove: " num
  if [[ $num -ge 0 && $num -lt ${#boxes[@]} ]]; then
    echo "${boxes[$num]} was removed."
    unset 'boxes[num]'
    boxes=("${boxes[@]}")
  else
    echo "That number doesn’t exist."
  fi
}