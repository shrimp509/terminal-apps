require 'rmagick'
require 'colorize'
include Magick

class Textify
  ALLOW_CHARS = '~!@#$%^&*()_+{}:">?`1234567890-=[];\',.'.chars.append(('a'..'z').to_a).append(('A'..'Z').to_a).flatten
  ASPECT_RATIO_PER_CHAR = 2
  BORDER_BIAS = 3
  COLORS = { 
    black:   '#000000', light_black:   '#686868',
    red:     '#C91C00', light_red:     '#FF6E67',
    green:   '#00C200', light_green:   '#5FF867',
    yellow:  '#C7C400', light_yellow:  '#FFFC67',
    blue:    '#0225C7', light_blue:    '#6871FF',
    magenta: '#C02EBE', light_magenta: '#FF77FF',
    cyan:    '#00C5C7', light_cyan:    '#60FDFF',
    white:   '#C7C7C7', light_white:   '#FFFFFF'
  }

  CHARS_BRIGHTNESS = {"~"=>37, "!"=>77, "@"=>179, "#"=>192, "$"=>168, "%"=>157, "^"=>24, "&"=>161, "*"=>78, "("=>99, ")"=>100, 
                      "_"=>32, "+"=>87, "{"=>123, "}"=>124, ":"=>63, "\""=>33, ">"=>93, "?"=>106, "`"=>0, "1"=>103, "2"=>148,
                      "3"=>131, "4"=>150, "5"=>154, "6"=>164, "7"=>96, "8"=>184, "9"=>164, "0"=>158, "-"=>45, "="=>95, "["=>117, 
                      "]"=>117, ";"=>77, "'"=>2, ","=>36, "."=>17, "a"=>165, "b"=>194, "c"=>131, "d"=>197, "e"=>163, "f"=>159,
                      "g"=>213, "h"=>171, "i"=>111, "j"=>139, "k"=>174, "l"=>112, "m"=>209, "n"=>149, "o"=>144, "p"=>221, "q"=>224,
                      "r"=>118, "s"=>156, "t"=>126, "u"=>138, "v"=>125, "w"=>169, "x"=>159, "y"=>182, "z"=>142, "A"=>220, "B"=>235,
                      "C"=>157, "D"=>200, "E"=>221, "F"=>181, "G"=>199, "H"=>227, "I"=>134, "J"=>144, "K"=>215, "L"=>162, "M"=>255,
                      "N"=>229, "O"=>187, "P"=>190, "Q"=>241, "R"=>221, "S"=>191, "T"=>185, "U"=>183, "V"=>166, "W"=>238, "X"=>203,
                      "Y"=>162, "Z"=>186}

  def initialize(img_path, color=false)
    @img = ImageList.new(img_path).last
    @brightness_map = CHARS_BRIGHTNESS
    @terminal_width = `tput cols`.strip.to_i
    @terminal_height = `tput lines`.strip.to_i
    @color = color
  end

  def start
    preprocessed_img = resize_to_fit_window(@img)
    
    # Calculate img brightness
    brightness_array = []
    preprocessed_img.each_pixel do |pixel, column, row|
      brightness_array.append(brightness(pixel))
    end

    result = ''
    preprocessed_img.each_pixel do |pixel, column, row|
      result += "\n" if column == 0
      brightness = normalize(brightness(pixel), brightness_array.max, brightness_array.min)
      char = find_best_char(brightness)
      if @color
        result += append_best_colorcode(char, rgb_color(pixel))
      else
        result += char
      end
    end

    puts result
  end

  private

  def resize_to_fit_window(img)
    width, height = if wide_type?(img)
                      width = @terminal_width - BORDER_BIAS
                      shrink_times = img.columns / width
                      [width * ASPECT_RATIO_PER_CHAR, img.rows / shrink_times]
                    else
                      height = @terminal_height - BORDER_BIAS
                      shrink_times = img.rows / height
                      [img.columns * ASPECT_RATIO_PER_CHAR / shrink_times, height]
                    end

    img.resize(width, height)
  end

  def terminal_width
    cols = `tput cols`.strip.to_i
  end

  def normalize(brightness, max_brightness, min_brightness)
    return 0 if max_brightness - min_brightness == 0
    255 * (brightness - min_brightness) / (max_brightness - min_brightness)
  end

  def brightness(pixel)
    Math.sqrt(
      0.299 * pixel.red**2 +
      0.587 * pixel.green**2 +
      0.114 * pixel.blue**2
    ).to_i
  end

  def wide_type?(img)
    @img.columns > @img.rows
  end

  def find_best_char(brightness)
    return ' ' if brightness < 15 || brightness > 240
    diff_map = @brightness_map.map do |k, v| 
      { k => (v - brightness).abs }
    end.reduce {|a,b| a.merge(b)}
    diff_map.key(diff_map.values.min)
  end

  def append_best_colorcode(char, color)
    char.colorize(find_best_colorcode(color))
  end

  def find_best_colorcode(target_color)
    COLORS.map do |color, code|
      { color => color_difference(target_color, hex_to_rgb(code)) }
    end.min_by {|hash| hash.values.last}.keys.last
  end

  def rgb_color(pixel)
    [pixel.red / 257, pixel.green / 257, pixel.blue / 257]
  end

  def color_difference(color1, color2)
    Math.sqrt((color1[0] - color2[0])**2 + (color1[1] - color2[1])**2 + (color1[2] - color2[2])**2)
  end

  def hex_to_rgb(hex)
    hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
  end
end

image_path = ARGV[0]
color = ARGV[1] == '--with-color' ? true : false
puts(Textify.new(image_path, color).start)

# def calc_chars_brightness
#   brightness_map = ALLOW_CHARS.map do |char|
#     # Empty img
#     tmp_img = Image.new(15, 15) { |img| img.background_color = 'black' }

#     # Draw char on empty img
#     drawing = Draw.new do |text|
#       text.pointsize = 12
#       text.fill = '#ffffff'
#       text.font = 'Courier'
#       text.gravity = NorthWestGravity
#     end
#     drawing.annotate(tmp_img, 0, 0, 0, 0, char) 

#     # Calculate brightness of a char
#     total_brightness = 0
#     count = 0
#     tmp_img.each_pixel do |p|
#       total_brightness += brightness(p)
#       count += 1
#     end
#     avg_brightness_of_char = total_brightness / count
#     { char => avg_brightness_of_char }
#   end.reduce {|a, b| a.merge(b)}

#   # Normalize the brightness to 0 ~ 255
#   brightness_map.map do |k, v|
#     new_value = 255 * (v - brightness_map.values.min) / (brightness_map.values.max - brightness_map.values.min)
#     { k => new_value }
#   end.reduce {|a, b| a.merge(b)}
# end