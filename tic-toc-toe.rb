=begin
1|2|3
-----
4|5|6
-----
7|8|9

勝利條件：橫、豎、斜連線就贏（8種排列組合）

實作重點：
1. 勝利條件的判斷
2. 顯示遊戲現況
3. 遊戲資料格式
4. 切換玩家
5. 玩家輸入

待完成：
1. 重構
=end

WIN_PATTERN = [
  [1,2,3], [4,5,6], [7,8,9],  # 橫
  [1,5,9], [3,5,7], # 斜
  [1,4,7], [2,5,8], [3,6,9] # 豎
].freeze

LEGAL_INPUTS = (1..9).to_a.freeze

PLAYERS = [:O, :X].freeze

CLEAR_LINE = "\x1b[1A\x1b[2K".freeze

def print_game
  reverse_game_data_format

  print(CLEAR_LINE * 100)

  print("
    #{get_cell_value(1)}|#{get_cell_value(2)}|#{get_cell_value(3)}
    -----
    #{get_cell_value(4)}|#{get_cell_value(5)}|#{get_cell_value(6)}
    -----
    #{get_cell_value(7)}|#{get_cell_value(8)}|#{get_cell_value(9)}
  \n")
end

def get_cell_value(count)
  @new_game_data[count.to_s] || count.to_s
end

def reverse_game_data_format
  @new_game_data = {}
  @game_data.invert.each do |values, k|
    values.each do |value|
      @new_game_data[value.to_s] = k
    end
  end
end

def show_and_update_game_data_from_input
  print("輪到 #{@current_player} 了, 你想下哪兒 [只能輸入 1 - 9]: ")
  number = gets
  print("\n")
  while !LEGAL_INPUTS.include?(number.to_i)
    print(CLEAR_LINE * 2)
    puts("[錯誤訊息] 錯誤的輸入值，你只能輸入 1 - 9！")
    print("輪到 #{@current_player} 了, 你想下哪兒 [只能輸入 1 - 9]: ")
    number = gets
  end
  @game_data[@current_player].append(number.to_i)
end

def judge
  for pattern in WIN_PATTERN
    return "#{@current_player.to_s} 獲勝!" if (@game_data[@current_player] & pattern).sort == pattern
  end
  return '平手' if @game_data.values.flatten.count == 9
  return nil
end

def next_player
  @current_player = (PLAYERS - [@current_player]).last
end

# GAME START
puts("開始玩「圈圈叉叉」囉～")

# Game Initialization
game = true
@current_player = PLAYERS.first
@game_data = {O: [], X: []}

# Main Logic
while game do
  print_game
  show_and_update_game_data_from_input
  winner_msg = judge
  game = false if !(winner_msg.nil?)
  next_player
end

# GAME OVER
print_game
puts("遊戲結束: #{winner_msg}")
