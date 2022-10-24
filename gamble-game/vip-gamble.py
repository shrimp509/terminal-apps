from random import randint
from getpass import getpass

account = ""
password = ""
money = 1000
bet = 100
game = True
login_failed = True

def register():
    global account, password
    account = input("請輸入您想註冊的帳號：")
    password = getpass("請輸入您的密碼：")
    print("恭喜您註冊成功 ヽ(●´∀`●)ﾉ\n")


def login():
    try_account = input("請輸入您的帳號：")
    if account == try_account:
        try_password = getpass("請輸入您的密碼：")
        if password == try_password:
            print("恭喜您成功登入！請跟著我進入大廳～\n")
            global login_failed
            login_failed = False
            return True
        else:
            print("密碼錯誤")
    else:
        print("帳號錯誤")

    return False


def show_info():
    print("----------------------------------------------")
    print("您目前有 %i 元，接下來每注 %i 元" % (money, bet))
    print("----------------------------------------------")


def high_card():
    global money, bet
    random_number = randint(1, 10)
    user_input = input("下好離手，你猜大還是猜小？（請輸入 大 或 小）：")
    if user_input == 'Q':
        global game
        game = False
        return
    result = '大' if random_number > 5 and random_number <= 10 else '小'
    if result == user_input:
        money += bet
        print("恭喜猜對ヽ(✿ﾟ▽ﾟ)ノ，您贏得 %i 元" % bet)
    else:
        money -= bet
        print("可惜猜錯了(´ﾟдﾟ`)，輸掉 %i 元" % bet)


def start_game():
    print("歡迎來到 VIP 娛樂城，請先註冊會員")
    register()
    while login_failed:
        print("請確認您的身份")
        login()

    print("歡迎光臨 VIP 娛樂城的大廳，接下來為您進行比大小的遊戲")
    print("當您想離開時，請輸入 Q")
    while game:
        show_info()
        high_card()
    
    print("感謝您光臨 VIP 娛樂城，您最後有 %i 元，歡迎下次光臨～" % money)


start_game()
