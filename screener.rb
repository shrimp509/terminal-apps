CSI = "\e[".freeze

require './colorful'
require 'pry'

class Screener
  class << self
    def clear_screen
      print("#{CSI}2J")
    end

    def move_cursor_to_top
      print("#{CSI}1;1H")
    end

    def clear_n2_top
      clear_screen
      move_cursor_to_top
    end

    def print_to_center(msg, clear: true)
      clear_n2_top if clear
      rows = `tput lines`.strip.to_i  # https://stackoverflow.com/questions/263890/how-do-i-find-the-width-height-of-a-terminal-window
      cols = `tput cols`.strip.to_i
      vertical_center = (rows / 2).to_i  + 1
      horizontal_center = (cols / 2).to_i
      if msg.match?(/(\e\[\d+m)*/)
        raw_msg = msg.match(/(\e\[\d+m)*([\p{Han}\w\d\s]+)(\e\[0m)*/)[2]
        horizontal_center = horizontal_center - (cal_word_length(raw_msg) / 2).to_i + 1
      end
      print("#{CSI}#{vertical_center};#{horizontal_center}H#{msg}")
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

Screener.print_to_center("HEllo WORLD".red)
sleep(1)
Screener.print_to_center("山姆怎麼那麼帥".red)
sleep(1)
Screener.print_to_center("Hello 山姆超帥的喲喲喲喲喲喲喲喲喲喲 Sam World".red)


while true

end
