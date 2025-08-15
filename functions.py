import winsound
from functools import reduce
from random import choice, randint, sample, seed, shuffle
from typing import Literal

import regex as re
from py_expression_eval import Parser

parser = Parser()

ops = ["+","-","*","/"]

def randints(a: int,b: int,*,k=1,duplicates=False) -> list[int]:

    output = [randint(a,b) for _ in range(k)] if duplicates else sample(range(a, b + 1), k=k)
    return output

def check_one_operation(nums,target):
    for num1 in nums:
        for num2 in nums:
            for op in ops:
                if eval_nums(num1,num2,op) == target:
                    return True
    return False

#Copied code from stack overflow to get the factors of a number
def factors(n) -> set[int]:    
    return set(reduce(list.__add__, 
                      ([i, n//i] for i in range(1, int(n**0.5) + 1) if n % i == 0)))

def create_puzzle(target_min,target_max,nums_min,nums_max,num_nums) -> tuple[int, list, str]:
    target = randint(target_min,target_max)
    current_value = target
    nums = []
    solution = f" = {target}"
    nums_remaining = num_nums
    while nums_remaining > 0:
        num = randint(nums_min,nums_max) * choice([-1,1])
        if nums_remaining >= 3:
            current_value += num
            solution = (f" + {-num}" if num < 0 else f" - {num}") + solution
        elif nums_remaining == 2:
            valid_factors = [x for x in factors(current_value) if nums_min <= x <= nums_max]
            num = choice(valid_factors)
            current_value //= num
            solution = f" * {num}" + solution
        else:
            num = current_value
            if not(nums_min <= num <= nums_max):
                #Program failed, run it again
                return create_puzzle(target_min,target_max,nums_min,nums_max,num_nums)
            current_value -= num
            solution = f"{num}" + solution

        nums.append(abs(num))
        nums_remaining -= 1
    return target, nums, solution

def create_target(nums: list[int],min_range,max_range) -> tuple[int, str]:
    target: int = -1
    solution: str = "Error"
    counter = 0
    while not min_range < target < max_range or target in nums or check_one_operation(nums,target):
        if counter >= 50:
            return -1, "Error"
        self_ops = ops.copy()
        numbers = sample(nums,k=len(nums))
        total_steps = len(nums)-1
        target = numbers[0]
        subtarget = target
        solution = f"{target}"
        for idx, number in enumerate(numbers[1:total_steps+1]):
            operation = choice(self_ops)
            if operation == "*":
                self_ops.remove(operation)
            if idx == total_steps-1 and "*" in self_ops:
                operation = "*"
                self_ops.remove(operation)
            while operation == "/" and not (target/number).is_integer():
                operation = choice(self_ops)
            solution += f" {operation} {number}"
            subtarget = eval_nums(subtarget,number,operation)
        target = int(subtarget)
        counter += 1
    return int(target), solution

def str_list(object=[]) -> list[str]:
    return [str(i) for i in object]

def int_list(object=[]) -> list[int]:
    return [int(i) for i in object]

def eval_nums(num1,num2,op) -> float|int:
    if op == "+":
        return num1 + num2
    if op == "-":
        return num1 - num2
    if op == "*":
        return num1 * num2
    if op == "/":
        return num1 / num2
    if op == "%":
        return num1 % num2
    raise ValueError(f"Unknown operation {op}")

def display_nums(nums,target):
    winsound.PlaySound("load.wav",winsound.SND_ASYNC)

    if len(nums) <= 1:
        print(f"Your numbers are {nums[0]}. ",end="")
    else:
        print(f"Your numbers are {", ".join(str_list(nums[:-1]))} and {nums[-1]}. ",end="")
    print(f"Your target is {target}.")

def eval_expression(expression:str,allowed_nums:list) -> tuple[list[int], int|str]:
    for x,item in enumerate(expression,start=1):
        if item in ops:
            continue
        if item in (" ","(",")"):
            continue
        if item.isnumeric():
            #Just ignore the numbers for now, we're checking them properly later
            continue
        #After checking the allowed characters, anything left will be a disallowed character.
        return [],f'Error, disallowed or unrecognised character "{item}" in position {x}.'
    

    nums = int_list(re.findall(r"\d+",expression))
    check_nums = allowed_nums.copy()
    for x,item in enumerate(nums):
        if item not in check_nums:
            error_msg = f"Error, you do not have the number {item}{f" after using {nums[x-1]}" if x-1 >= 0 else ""}. "
            if len(allowed_nums) <= 1:
                error_msg += f"Your numbers are {allowed_nums[0]}. "
            else:
                error_msg += f"Your numbers are {", ".join(str_list(allowed_nums[:-1]))} and {allowed_nums[-1]}. "
            return [],error_msg
        check_nums.remove(item)
    
    try:
        answer = parser.parse(expression).evaluate({})
    except Exception:
        return [],"Error, failed to parse expression."
    if not answer.is_integer():
        return [],"Error, answer is not whole."
    if answer < 0:
        print("Answer was negative, flipped to be positive")
        answer = abs(answer)
    return nums, int(answer)