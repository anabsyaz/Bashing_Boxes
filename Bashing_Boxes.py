#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import math
import time

RandomItems = ["Dresser", "Jar", "Chocolate Bar", "Sofa", "Apple Tree",
               "Shawl", "Butterfly", "Underwear", "Coat Rack", "Hair Dryer"]


def print_list():
    print(RandomItems)


def print_item():
    print(f"Here are the current amount of items: {len(RandomItems)}")
    time.sleep(1)
    int(number_in_array=input("Enter the number of the item: "))

    if 0 < number_in_array < len(RandomItems):
        print(f"{RandomItems[number_in_array]}")
    else:
        print("That number does not exist in the index")


def add_item():
    print(f"Here are the current items: {RandomItems}")
