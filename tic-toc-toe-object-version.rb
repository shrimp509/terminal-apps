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
2. 加上顏色
=end

WIN_PATTERN = [
  [1,2,3], [4,5,6], [7,8,9],  # 橫
  [1,5,9], [3,5,7], # 斜
  [1,4,7], [2,5,8], [3,6,9] # 豎
].freeze
LEGAL_INPUTS = (1..9).to_a.freeze
CLEAR_LINE = "\x1b[1A\x1b[2K".freeze
INPUT_GUIDELINE = "輪到 %s 了, 你想下哪兒 [只能輸入 1 - 9]: ".freeze
ERROR_INPUT = "[錯誤訊息] 錯誤的輸入值，你只能輸入 1 - 9！".freeze
ERROR_DUPLICATE_INPUT = "[錯誤訊息] 想蓋掉別人的地盤？換個地方填吧".freeze
WINNER_MSG = "%s 獲勝!".freeze
START_MSG = "開始玩「圈圈叉叉」囉～".freeze
GAME_BOARD = "
  %s|%s|%s
  -----
  %s|%s|%s
  -----
  %s|%s|%s
\n".freeze

class TicTacToeGame
  def initialize
    @game = true
    puts(START_MSG)

    print("Player1 的符號？ ")
    @p1 = Player.new(gets.strip)
    print("Player2 的符號？ ")
    @p2 = Player.new(gets.strip)
    print("誰先開始[p1 或 p2]？ ")
    @current_player =
        case gets.strip
        when 'p1'
          @p1
        when 'p2'
          @p2
        else
          raise("輸入錯誤")
        end
    @players = [@p1, @p2].freeze
  end

  def start
    while @game do
      print_game_board
      show_and_update_game_data_from_input
      over_msg = judge
      next_player
    end

    print_game_board
    puts("遊戲結束: #{over_msg}")
  end

  private

  def print_game_board
    new_game_data = reverse_game_data_format(game_data)

    print(CLEAR_LINE * 100)

    print(
      GAME_BOARD % [get_cell_value(1), get_cell_value(2), get_cell_value(3),
                   get_cell_value(4), get_cell_value(5), get_cell_value(6),
                   get_cell_value(7), get_cell_value(8), get_cell_value(9)]
    )

    print("\n")
  end

  def get_cell_value(count)
    @new_game_data[count.to_s] || count.to_s
  end

  def reverse_game_data_format(game_data)
    new_game_data = {}
    game_data.invert.each do |values, k|
      values.each do |value|
        new_game_data[value.to_s] = k
      end
    end
    @new_game_data = new_game_data
    return new_game_data
  end

  def show_and_update_game_data_from_input
    input_continue = true

    while input_continue
      print_game_board
      print_err_msg
      number = get_user_input

      if !LEGAL_INPUTS.include?(number.to_i)
        @err_msg = ERROR_INPUT
        next
      end

      if reverse_game_data_format(game_data)[number]
        @err_msg = ERROR_DUPLICATE_INPUT
        next
      end

      input_continue = false
    end

    @current_player.board_data.append(number.to_i)
  end

  def get_user_input
    print(INPUT_GUIDELINE % @current_player.sign)
    input = gets.strip
    return input
  end

  def print_err_msg
    unless @err_msg.nil?
      puts(@err_msg)
      @err_msg = nil
    end
  end

  def judge
    # judge winner
    for pattern in WIN_PATTERN
      win = (@current_player.board_data & pattern).sort == pattern
      over_msg = (WINNER_MSG % @current_player.to_s) if win
    end

    # judge full game
    full_game = game_data.values.flatten.uniq.sort == LEGAL_INPUTS
    over_msg = '平手' if full_game

    # break game loop if over
    @game = false unless over_msg.nil?

    return over_msg
  end

  def next_player
    @current_player = (@players - [@current_player]).last
  end

  def game_data
    { @players.first.sign => @players.first.board_data, @players.last.sign => @players.last.board_data }
  end
end

class Player
  attr_reader :sign, :board_data, :points

  def initialize(sign)
    @sign = sign
    @board_data = []
    @points = 0
  end

  def put_sign(where)
    @board_data.append(where)
  end

  def win
    @points += 1
    "現在分數是 #{points} 分"
  end

  def to_s
    @sign
  end
end

TicTacToeGame.new.start
