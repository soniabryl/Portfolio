### Creating a function which returns the longest word in the given string
def get_longest_word( s: str) -> str:
    longest_word = ''
    current_word = ''
    for char in s:
        if char.isspace():
            if len(current_word) > len(longest_word):
                longest_word = current_word
            current_word = ''
        else:
            current_word += char
    if len(current_word) > len(longest_word):
        longest_word = current_word
    return longest_word
#
#
#
#Creating a function that checks whether a string is a palindrome or not
def check_str(s: str) -> bool:
    s_len = len(s)
    for i in range(s_len//2):
        if s[i] == s[s_len - i -1]:
            return True
    return False
#
#
#
# Bisection search(number guessing)
l = 0
h = 100
guess = (h + l)//2
print("Please think of a number between 0 and 100!")
print ("Is your secret number", str(guess) + "?")
print("Enter 'h' to indicate the guess is too high. Enter 'l' to indicate the guess is too low. Enter 'c' to indicate I guessed correctly.", end=" ")
user_input = input()

while user_input != "c":
    if user_input == "h":
        h = guess
        guess = (h + l)//2
        print ("Is your secret number", str(guess) + "?")
        user_input = input("Enter 'h' to indicate the guess is too high. Enter 'l' to indicate the guess is too low. Enter 'c' to indicate I guessed correctly.", end=" ")
        user_input = input()
    elif user_input == "l":
        l = guess
        guess = (h + l)//2
        print ("Is your secret number", str(guess) + "?")
        user_input = input("Enter 'h' to indicate the guess is too high. Enter 'l' to indicate the guess is too low. Enter 'c' to indicate I guessed correctly.", end=" ")
        user_input = input()
    else:
        print("Sorry, I did not understand your input.")
        print ("Is your secret number", str(guess) + "?")
        user_input = input("Enter 'h' to indicate the guess is too high. Enter 'l' to indicate the guess is too low. Enter 'c' to indicate I guessed correctly.", end=" ")
        user_input = input()

print ("Game over. Your secret number was:", guess)

#
#
#
#House down payment
### Gains (savings and investments)
current_saving = 0
annual_rate = r = 0.04 # 4%

### Salary
# monthly_salary and monthly_portion_saved are the same the whole year
# thus monthly_salary_saved as well
annual_salary = float(input ("Enter your annual salary: "))
monthly_salary = annual_salary / 12
monthly_portion_saved = float(input("Enter the percent of your salary to save, as a decimal: "))
monthly_salary_saved = monthly_salary * monthly_portion_saved

### Housing costs and payments
total_cost = float(input("Enter the cost of your dream home: "))
portion_down_payment = 0.25 # 25%
down_payment = total_cost * portion_down_payment

semi_annual_raise = float(input("Enter the semi annual raise, as a decimal: "))

result = 0 # the number of months to make a down_payment

while current_saving <= down_payment:
    # monthly_saving and monthly_earn must be reevaluated every month and added to current_saving
    monthly_earn = current_saving * annual_rate / 12 # monthly return from investments
    monthly_saving = monthly_salary_saved + monthly_earn
    current_saving += monthly_saving
    result += 1
    if result % 6 == 0:
        annual_salary *= 1 + semi_annual_raise
        monthly_salary = annual_salary / 12
        monthly_salary_saved = annual_salary / 12 * monthly_portion_saved

print (result)

#
#
#
#Cafe
import random

num_cashiers = 1
num_cooks = 2
total_num_customers = 0

waiting_to_order = 0
waiting_for_food = 0
cook_fills_order = 0
shift_time = 5
hour = 60
for time in range (hour * shift_time):
# Customers arrive every minute and line up to order.
    waiting_to_order = waiting_to_order + random.randint(0, 6)

# Each cashier can take up to three orders per minute.
    new_orders = min(num_cashiers * 3, waiting_to_order)

# After ordering, customers wait for their food to be made.
    waiting_to_order = waiting_to_order - new_orders
    waiting_for_food = waiting_for_food + new_orders
    cook_fills_order = min(num_cooks, waiting_for_food)
    waiting_for_food = waiting_for_food - cook_fills_order
    total_num_customers = total_num_customers + cook_fills_order



    print(str(waiting_to_order) + " customers waiting to order.")
    print(str(waiting_for_food) + " customers waiting for food.")
print(str(total_num_customers))