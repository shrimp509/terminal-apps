from random import randint

def get_random_answer():
    answer = ''
    while len(answer) < 4:
        answer = remove_duplicate(str(randint(1000, 9999)))
    return answer


def remove_duplicate(answer):
    return ''.join(set(answer))


def get_user_input():
    return input('Enter your guess[4 numbers]: ')


def get_hint(answer, user_input):
    # answer: 1234, user_input: 3512
    full_correct = 0
    half_correct = 0
    for index, char in enumerate(user_input):
        if char == answer[index]:
            full_correct += 1
        elif char in answer:
            half_correct += 1
    return "%dA%dB" % (full_correct, half_correct)


def check_game_over(hint):
    return True if hint == '4A0B' else False


def start_game():
    answer = get_random_answer()
    print("\033[0;30;40m%s\033[0m" % answer)
    while True:
        user_input = get_user_input()
        hint = get_hint(answer, user_input)
        print(hint)

        if check_game_over(hint):
            print("Congratulation!")
            break


start_game()
