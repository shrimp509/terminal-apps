import random

money = 300
bet = 100 # 每注
min, max = 1, 100
win_percent = int(input("請輸入莊家贏的機率(0~100)之間: "))

print("歡迎光臨山姆小賭場\n\n")
while True:
	print("您的籌碼目前有 %d 元" % money)
	print("每注 %d 元\n\n" % bet)
	print("現在要玩的是猜大小：請輸入'大' 或 '小' 來進行遊戲，如果要離場，請輸入 'Q'")
	user_input = input("您要猜大或小呢？：")
	if user_input == 'Q':
		break

	if random.randint(min, max) > win_percent:
		print("恭喜猜對了～\n")
		money += bet
	else:
		print("可惜答錯了QQ，再接再厲！\n")
		money -= bet

	if money <= 0:
		break


print("感謝惠顧，歡迎再來")
