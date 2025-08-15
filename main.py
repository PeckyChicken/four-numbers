from functions import *
from py_expression_eval import Parser
from datetime import date

testing = False
try:
    #This is a special import for PyScript to access the DOM
    from js import document, console # type: ignore
except ImportError:
    document = None
    testing = True

min_range = 2
max_range = 60

num_nums = 4

test_parser = Parser()

help_text = '''The aim of the game is to combine the numbers you have using the 4 classic mathematical operations (addition +, subtraction -, multiplication * and division /) to reach your target.
Once you combine 2 numbers they get replaced by the resulting number. You can type "nums", "numbers" or "n" at any time to see your current numbers, or "target" to see your target.
A number can only be used once, but it does not have to be used at all.
If you are struggling, you can type "factors <number>" to find the factors of the number, or just "factors" to find the factors of the target number.
If you want to test out some math without having the numbers, you can type "test " followed by your math.
If you make a mistake you can type "undo" or "u" to undo it.
You can always type "restart", "reset", "undoall" or simply just "r", to restart the puzzle.
If things get too cluttered, type "c", "clear" or "cls" to clear the screen.
Expressions may contain any of the numbers you have, parentheses and any of the 4 listed operations.
You can do multiple expressions in one line by separating them with ",". You will be informed if something went wrong.
You can always type "help" to get this list up again.
'''

mini_help_text = 'You can use + - * or / and may use each number at most once. You can separate expressions with ",".\nType "help" to learn more, "undo" to undo your last move, "restart" or "r" to restart the puzzle or "nums" to see your current numbers.\nType "factors" to see the factors of the target number, or "test <expression>" to try out some math.'

START_DATE: date = date(2025, 8, 15)
date_today: date = date.today()

puzzle_id = (date_today - START_DATE).days
print(puzzle_id)
    
def setup_puzzle(puzzle_id: int) -> tuple[int, list[int], str]:
    target = -1
    allowed_nums = []
    solution = ""
    seeded = puzzle_id
    while target == -1:
        seed(seeded)
        allowed_nums = sorted(randints(min_range,max_range,k=num_nums,duplicates=False))
        target, solution = create_target(allowed_nums,min_range=num_nums*4,max_range=num_nums*10)
        if target == -1:
            seeded += 0.001
    
    return target, allowed_nums, solution

def _on_page_load():
    print("Page loaded, setting up puzzle...")
    if not testing:
        console.log("Page loaded, setting up puzzle...") #type: ignore
    if document is not None:
        document.getElementById("puzzle_id").innerText = f"Puzzle #{puzzle_id}"
    else:
        print(f"Puzzle #{puzzle_id}")


#while True:
#    seeded = puzzle_id

#    if mode == "leveled":
#        seed(seeded)
#        print(f"Puzzle #{puzzle_id}")
        
#        max_range = puzzle_id+10
#    history = []
    

#    target, allowed_nums, solution = setup_puzzle(puzzle_id)

    
#    display_nums(allowed_nums,target)
#    if attempts == 0:
#        print(mini_help_text)
#    print("Go!")
#    while target not in allowed_nums: #Keep going until either player wins or gives up.
#        expressions = input("> ").strip().lower()
#        if len(expressions) == 0:
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            continue

#        if expressions in ("n","nums","numbers","num","number"):
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            display_nums(allowed_nums,target)
#            continue

#        if expressions in ("g","goal","target"):
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            print(f"Your target is {target}.")
#            continue

#        if expressions in ("skip","pass","stop","new","newgame","new game","next") and mode == "random":
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            print(f"The solution was {solution}. Starting a new game...")
#            break

#        if expressions in ("h","help"):
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            print(help_text)
#            continue

#        if expressions in ("restart","reset","undoall","undo all","startover","start over","r"):
#            print("Restarting puzzle...")
#            if mode == "leveled":
#                print(f"Puzzle #{puzzle_id}")
#            for move in history[::-1]:
#                allowed_nums.remove(move[1])
#                allowed_nums.extend(move[0])
#            allowed_nums.sort()
#            history.clear()
#            display_nums(allowed_nums,target)
#            winsound.PlaySound("Sounds/restart.wav",winsound.SND_ASYNC)
#            continue
        
#        if expressions.split()[0] in ("factors","f","factorise","factorize"):
#            if len(expressions.split()) > 1:
#                if expressions.split()[1].replace("-","").isnumeric():
#                    num = int(expressions.split()[1])
#                elif expressions.split()[1].replace("-","").replace(".","").isnumeric() and "." in expressions.split()[1]:
#                    winsound.PlaySound("Sounds/error.wav",winsound.SND_ASYNC)
#                    print(f"Error, {expressions.split()[1]} is not an integer.")
#                    continue
#                else:
#                    num = target
#            else:
#                num = target
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            num_factors = sorted(list(factors(num)))
#            print(f"The factors of {num} are {", ".join(str_list(num_factors[:-1]))} and {num_factors[-1]}. ")
#            continue
        
#        if expressions.startswith("test "):
#            winsound.PlaySound("Sounds/success.wav",winsound.SND_ASYNC)
#            expression = expressions[5:]
#            try:
#                result = test_parser.parse(expression).evaluate({})
#            except Exception:
#                result = "ERROR"
#            print(f"TEST: {expression} evaluated to {result}")
#            continue

#        if expressions in ("c","cls","clear","clearscreen","clear screen"):
#            winsound.PlaySound("Sounds/enter.wav",winsound.SND_ASYNC)
#            print("Clearing screen...")
#            os.system("cls")
#            display_nums(allowed_nums,target)
#            continue
        
#        if expressions in ("u","undo","back"):
#            if len(history) < 1:
#                print("Nothing to undo.")
#                winsound.PlaySound("Sounds/error.wav",winsound.SND_ASYNC)

#                continue
#            winsound.PlaySound("Sounds/undo.wav",winsound.SND_ASYNC)
#            lastmove = history[-1]
#            allowed_nums.remove(lastmove[1])
#            allowed_nums.extend(lastmove[0])
#            allowed_nums.sort()
#            history.pop(-1)
#            print(f"{lastmove[1]} has been reverted to {", ".join(str_list(lastmove[0][:-1]))} and {lastmove[0][-1]}")
#            continue    

#        expressions = expressions.split(",")
#        for expression in expressions:
#            expression = expression.strip()
#            if expression.startswith(tuple(ops)):
#                if len(history) == 0:
#                    print("Error, dangling operation.")
#                    winsound.PlaySound("Sounds/error.wav",winsound.SND_ASYNC)
#                    continue
#                expression = f"{history[-1][1]}{" " if expression[1] == " " else ""}" + expression
#            evaluation = eval_expression(expression,allowed_nums)
#            if type(evaluation[1]) == str: #An error message has been returned
#                print(evaluation)
#                winsound.PlaySound("Sounds/error.wav",winsound.SND_ASYNC)
#                continue
#            winsound.PlaySound("Sounds/success.wav",winsound.SND_ASYNC)
#            nums  = evaluation[0]
#            answer = int(evaluation[1])
#            history.append(evaluation)
#            print(f"{expression} = {answer}")
#            for i in nums:
#                allowed_nums.remove(i)
#            allowed_nums.append(answer)
#            allowed_nums.sort()
#    if target in allowed_nums:
#        print(f"You successfully got {target}! Starting a new game...")  
#    attempts += 1
#    if mode == "leveled":
#        puzzle_id += 1
#        with open("puzzle_id.txt","w") as f:
#            f.write(str(puzzle_id))
#    print("-"*50)
