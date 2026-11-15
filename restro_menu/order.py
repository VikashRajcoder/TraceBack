menu = {
    'pizza' : 179,
    'french fry' : 80,
    'coffee' : 60,
    'tea' : 10,
    'burger' : 50,
    'cold coffee' : 60,
    'pasta' : 40
}

print("WELCOME TO MY RESTRONENT\n")
print("pizza : 179\nfrench fry : 80\ncoffee : 60\ntea : 10\nburger : 50\ncold coffee : 60\npasta : 40")

total_order = 0
item_1 = input("What you want to order:")
if item_1 in menu:
    total_order += menu[item_1]
    print(f"your item {item_1} has been added to order")

else:
    print(f"{item_1} is not available yet! order other things")

another_order = input("Do you want to order anything?(YES/NO):")
if another_order == "YES":
    item_2 = input("Enter senond order:")
    if item_2 in menu:
        total_order += menu[item_2]
        print(f"your item {item_2} has been added to order")
    else:
        print(f"{item_2} is not available! order other things")
print(f"Total amount to pay {total_order}Rs.")


