ESCAPE_PREFIX = "\e[".freeze
ESCAPE_SUFFIX = "\e[0m".freeze

WORDS_COLOR_CODES = {
  black: 30,
  red: 31,
  green: 32,
  yellow: 33,
  blue: 34,
  white: 37,
  gray: 90,
  bright_red: 91,
  bright_green: 92,
  bright_yellow: 93,
  bright_blue: 94,
  bright_cyan: 96,
  bright_white: 97
}.freeze

BACKGROUND_COLOR_CODES = {
  black: 40,
  red: 41,
  green: 42,
  yellow: 43,
  blue: 44,
  white: 47,
  gray: 100,
  bright_red: 101,
  bright_green: 102,
  bright_yellow: 103,
  bright_blue: 104,
  bright_cyan: 106,
  bright_white: 107
}.freeze

DECO_CODES = {
  bold: 1,
  italic: 3,
  underline: 4,
  reverse: 7,
  strike: 9
}

class Colorful
  class << self
    def available_colors
      WORDS_COLOR_CODES.keys
    end

    def setup
      String.setup_colorful
      puts('Setup colorful success.'.green)
      puts('Hint: puts("Hello".red)'.gray)
    end

  end
end

class String
  def self.setup_colorful
    WORDS_COLOR_CODES.each do |word_color, _|
      String.define_method(word_color) do
        "#{ESCAPE_PREFIX}#{WORDS_COLOR_CODES[word_color]}m#{self}#{ESCAPE_SUFFIX}"
      end
    end

    BACKGROUND_COLOR_CODES.each do |bg_color, _|
      String.define_method("bg_#{bg_color}") do
        "#{ESCAPE_PREFIX}#{BACKGROUND_COLOR_CODES[bg_color]}m#{self}#{ESCAPE_SUFFIX}"
      end
    end

    DECO_CODES.each do |deco, _|
      String.define_method(deco) do
        "#{ESCAPE_PREFIX}#{DECO_CODES[deco]}m#{self}#{ESCAPE_SUFFIX}"
      end
    end
  end
end

Colorful.setup
