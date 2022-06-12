CSI = "\e[".freeze
HEADER_HEIGHT = 7

require './colorful'
require 'pry'

class Screener
  class << self
    def print_to_center(msg, clear: true)
      clear_n2_top if clear
      vertical_center = (height / 2).to_i  + 1
      horizontal_center = (width / 2).to_i
      if msg.match?(/(\e\[\d+m)*/)
        raw_msg = msg.match(/(\e\[\d+m)*([\p{Han}\w\d\s]+)(\e\[0m)*/)[2]
        horizontal_center = horizontal_center - (cal_word_length(raw_msg) / 2).to_i + 1
      end
      print("#{CSI}#{vertical_center};#{horizontal_center}H#{msg}")
    end

    def print_header(msg)
      print_header_frame
      print_header_words(msg)
    end

    def print_header_frame
      move_cursor_to_top_left
      print("#" * width)
      (HEADER_HEIGHT - 1).times do
        move_cursor_down(1)
        print_line_left('#')
        print_line_right('#')
      end
      move_cursor_to_line_start
      print("#" * width)
    end

    def print_header_words(msg)
      row = (HEADER_HEIGHT / 2).to_i + 1
      frame = 2
      col = ((width - frame - cal_word_length(msg)) / 2).to_i + 1
      move_cursor_absolute(row, col)
      print(msg)
    end

    def print_line_left(msg)
      move_cursor_to_line_start
      print(msg)
    end

    def print_line_right(msg)
      move_cursor_to_line_start
      move_cursor_horizontal(width - cal_word_length(msg) + 1)
      print(msg)
    end

    # private

    def clear_screen
      print("#{CSI}2J")
    end

    def move_cursor_to_top_left
      print("#{CSI}1;1H")
    end

    def clear_n2_top
      clear_screen
      move_cursor_to_top_left
    end

    def move_cursor_to_line_start
      print("#{CSI}1G")
    end

    def move_cursor_down(lines)
      move_cursor_vertical(-lines)
    end

    def move_cursor_up(lines)
      move_cursor_vertical(lines)
    end

    def move_cursor_absolute(rows_from_top, cols_from_start)
      print("#{CSI}#{rows_from_top};#{cols_from_start}H")
    end

    def move_cursor_vertical(lines)
      lines > 0 ? print("#{CSI}#{lines}A") : print("#{CSI}#{-lines}B")
    end

    def move_cursor_horizontal(length)
      length > 0 ? print("#{CSI}#{length}C") : print("#{CSI}#{-length}D")
    end

    def width
      cols = `tput cols`.strip.to_i
    end

    def height
      rows = `tput lines`.strip.to_i
    end

    def cal_word_length(word)
      result = word_analyze(word)
      return result[:en] + result[:zh] * 2
    end

    def word_analyze(word)
      result = word.chars.map { |char| char.match?(/[\w\d\s]/) }
      {en: result.count(true), zh: result.count(false)}
    end
  end
end


Screener.clear_screen
Screener.print_header('山姆老弟，我最希換')

# Screener.print_to_center("HEllo WORLD".red)
# sleep(1)
# Screener.print_to_center("山姆怎麼那麼帥".red)
# sleep(1)
# Screener.print_to_center("Hello 山姆超帥的喲喲喲喲喲喲喲喲喲喲 Sam World".red)



while true
end
