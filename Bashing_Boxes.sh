#!/bin/bash
clear
#This is the array for the random objects
random_items=("Dresser" "Jar" "Chocolate bar" "Sofa" "Apple tree" "Shawl" "Butterfly" "Underwear" "Coat rack" "Hair dryer") 

#shows the full list of objects
print_list() {
  echo "Here is the list:"
  for item in "${!random_items[@]}"; do
    echo "$item: ${random_items[$item]}"
  done
  sleep 2
  menu
}

#shows one object by its number
print_item() {
  echo "Here are all the current number of items 0-$((${#random_items[@]} - 1))"
  sleep 2
  read -p "Enter the number of the item: " number
  if [[ $number -ge 0 && $number -lt ${#random_items[@]} ]]; then
    echo "Item $number is ${random_items[$number]}"
  else
    echo "That number doesn’t exist."
  fi
  sleep 2
  menu
}

# add a new item
add_item() {
  read -p "Enter something to add: " thing
  random_items+=("$thing")
  echo "$thing added to the list."
  sleep 2
  menu
}

# remove the last item
remove_last() {
  unset 'random_items[-1]'
  echo "Last item removed."
  sleep 2
  menu
}

# remove an item by its number
remove_item() {
  echo "Here are all the current number of items ${#random_items[@]}, Starting from 0"
  read -p "Enter the number of the item to remove: " num
  if [[ $num -ge 0 && $num -lt ${#random_items[@]} ]]; then #checks if the number is valid if it is it removes the item
    echo "${random_items[$num]} was removed."
    unset 'random_items[num]'
    random_items=("${random_items[@]}")
  else
    echo "That number doesn’t exist."
  fi
  sleep 2
  menu
}

#deletes a save file from the /data directory
delete_save() {
  read -p "Enter the name of the save file to delete: " filename
  filepath="data/${filename}.txt"
  if [[ -f "$filepath" ]]; then #finds if the file exists
    rm "$filepath"
    echo "Deleted $filepath"
  else
    echo "File $filepath does not exist."
  fi
  sleep 2
  menu
}

#saves the file to the /data directory
save_file() {
  read -p "Enter the name of your save file: " filename
  filepath="data/${filename}.txt"
  
  for item in "${random_items[@]}"; do
    echo "$item"
  done > "$filepath"
  #I can load the array easier with mapfile -t random_items < "$filepath"
  
  echo "Saved to $filepath"
  sleep 2
  menu
}

#loads the file from the /data directory
load_file() {
  read -p "Enter the name of the save file to load: " filename
  filepath="data/${filename}.txt" #specifies the path to the file
  
  if [[ -f "$filepath" ]]; then
    mapfile -t random_items < "$filepath" #loads the file into the array
    echo "Loaded from $filepath"
  else
    echo "File $filepath does not exist."
  fi
  sleep 2
  menu
}

#lists all save files in the /data directory
list_saves() {
  echo "Available save files in data/:"
  ls data/
  sleep 2
  menu
}

#loads the object pool from the warehouse_of_objects.txt file
load_object_pool() {
  if [[ -f "/home/farrow/Bashing_Boxes/warehouse_of_objects.txt" ]]; then
    mapfile -t object_pool < "/home/farrow/Bashing_Boxes/warehouse_of_objects.txt"
  else
    echo "Object pool file not found!"
    exit 1
  fi
}

prompt_for_box_size() {
  read -p "Enter the number of items for the random box (Max 30 objects, Min 1 object): " box_size
  if [[ $box_size -lt 1 || $box_size -gt 30 ]]; then
    echo "Invalid input. Defaulting to 10."
    box_size=10
  fi
}

#generates a random box with items from the warehouse of objects file
generate_box_randomly() {
  random_items=() #clears the current array
  load_object_pool
  prompt_for_box_size
  mapfile -t random_items < <(shuf -n "$box_size" /home/farrow/Bashing_Boxes/warehouse_of_objects.txt)
  #The < <() is called process substitution It lets a command’s output be treated like a file for input redirection.
  echo "Generated a random box with $box_size items."
  menu
}

#searches the current box for an item
search_box_for_item() {
  read -p "Enter the item to search for in the current box: " search_item
  
  for item in "${random_items[@]}"; do
    if [[ "$item" == *"$search_item"* ]]; then
      echo "Found: $item"
    fi
  done
  
  if ! $found; then
    echo "Item '$search_item' not found in the current box."
  fi
  
  sleep 2
  menu
}

#searches all save files in the /data directory for an item
search_file_for_item() {
  read -p "Enter the item to search for in save files: " search_item
  search_file=$(grep -ril "$search_item" data/) #searches all files in the data/ directory for the item, -r is recursive, -i is case insensitive, -l lists only filenames
  if [[ -n "$search_file" ]]; then
    echo "Found in the following files:"
    echo "$search_file"
  fi
  sleep 2
  menu
}

#main menu function
menu() {
  echo "==========================="
  echo "BASHING BOXES MENU"
  echo "1. Print list"
  echo "2. Print one item"
  echo "3. Add new item"
  echo "4. Remove last item"
  echo "5. Remove item by number"
  echo "6. Delete save file"
  echo "7. Save current box to file"
  echo "8. Load box from file"
  echo "9. List all boxes from file"
  echo "10. generate random box"
  echo "11. Search box for item"
  echo "12. Search file for item"
  echo "13. "
  echo "14. Clear Terminal"
  echo "15. Exit"
  echo "==========================="
  read -p "Pick an option (1-15): " choice

  case $choice in 
    1) print_list ;;
    2) print_item ;;
    3) add_item ;;
    4) remove_last ;;
    5) remove_item ;;
    6) delete_save ;;
    7) save_file ;;
    8) load_file ;;
    9) list_saves ;;
    10) generate_box_randomly ;;
    11) search_box_for_item ;;
    12) search_file_for_item ;;
    13)  ;;
    14) clear; menu ;;
    15) echo "Bye"; clear; exit ;;
    *) echo "Not a valid choice." ;;
  esac
}

echo "⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⡠⢀⠔⠬⣁⠒⡀⠤⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠤⠀⡒⠠⠉⠔⠠⡑⢠⠃⠌⢒⠀⡃⠜⡀⢃⢰⣀⠮⡄⢖⡠⠤⣀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⢀⡀⠠⠀⠂⡀⠡⠐⢀⠁⢂⠡⢀⠑⡈⠌⠁⠄⡁⠌⢐⣠⠡⠴⡒⠪⢍⡒⢌⣒⠭⠆⠃⡉⠄⠂⡈⠄⠐⡀⠂⠄⠀⡀⠀⠀⠀
⡔⠄⡅⡀⠀⠀⠐⠀⠐⠀⠈⠀⠈⠀⠀⠂⢀⢀⠤⠬⠂⢆⠩⡁⢆⣉⠦⠡⠓⠂⠉⠀⠀⠀⠀⠄⠠⠀⠁⡀⠐⠀⠀⠀⠀⢀⢀⢠⠡⢠
⠀⠀⠀⠈⠀⠃⠀⠆⠠⠄⢀⡀⠤⠠⠒⡈⠅⡈⡐⡄⠩⠀⠒⠁⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠠⠄⠰⠀⠋⠈⠁⠀⠀⢠
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢈⠐⠈⠠⠓⠐⠄⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠠⢀⠐⠀⠃⠀⠁⠀⠀⠀⠀⠀⠀⠀⡀⠄⠰
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠀⠀⢸⠀⠀⠁⠀⠀⠰⠀⢀⠀⡀⢀⠀⢠⠀⠄⠀⠃⠈⠀⠀⠀⠀⠀⠀⠀⠀⢀⠠⠀⠂⡁⠐⠠⢀⠱
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⠠⠀⣸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠄⢀⠁⠠⠀⠌⡐⠠⡁⠒⡀⠎
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠀⠠⠐⠈⡀⠄⠂⠄⡨⠐⡁⠒⡠⢁⠆⠱⣀⠃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠐⠈⡀⠄⠂⠄⠡⠐⣈⠰⠁⠤⠑⡈⠥⡐⢡⠊⠥⣀⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠂⡀⢁⠂⠄⠡⠐⣈⠐⡉⢄⠃⡄⢢⠉⢆⠱⡈⢆⡑⢢⡉⢖⠰⠊
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢁⠰⢀⡈⠆⢁⠁⢆⠸⡀⠎⡰⠈⡆⠉⡆⢱⠸⣀⠎⣁⠸⡈⢇⠇
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⠂⠔⢂⠰⡈⠆⡩⢐⠢⡑⠌⡔⠣⢌⡱⢌⡱⢢⡑⢎⡔⢫⡜⡜⡂
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠈⡜⣀⠣⡐⡡⢆⢡⢒⡡⢍⡒⣍⠲⡘⢦⡑⣣⠜⣎⡜⣣⢞⡱⡃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠰⡐⡄⣃⠖⡡⢎⡂⢧⡘⢦⠱⣌⢣⡝⢦⡙⢦⡛⣴⡙⣦⢏⢶⡃
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡆⡱⢢⠅⣎⠱⣢⢙⠦⣙⠦⣛⢬⠳⣜⢣⡝⣣⡝⣶⢹⡖⣯⢞⡅
⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠰⣏⡔⢣⡚⡴⢋⡴⣋⠞⣥⢛⡜⣎⣗⣮⢷⡿⣱⢻⡜⣧⣻⡜⣯⠆
⠣⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣇⠞⣥⡹⣜⢣⡳⣍⢾⣡⡿⣾⣿⣽⣿⣞⣿⣱⢟⡾⣱⢧⣿⡽⠷
⠀⠀⠉⠐⠠⢀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣯⠞⣦⢳⣜⣧⣷⣟⣿⣯⠷⣿⣯⣻⣷⢫⣷⢯⣾⡽⠟⠛⠁⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠁⠒⠠⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣷⡿⣞⣯⣯⢿⣽⡞⣷⣯⣟⣿⣷⣿⡿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠂⠄⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡗⣿⣿⠷⣿⣿⣽⣿⡿⠿⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠐⠠⠄⡀⠀⠀⠀⠀⣿⣟⣷⣿⣿⠿⠞⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠐⠠⢀⣿⠟⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀"
menu