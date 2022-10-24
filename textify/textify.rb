require 'rmagick'
require 'colorize'
include Magick

class Textify
  ALLOW_CHARS = '~!@#$%^&*()_+{}:">?`1234567890-=[];\',.'.chars.append(('a'..'z').to_a).append(('A'..'Z').to_a).flatten
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

  def initialize(img_path, color=false)
    @img = ImageList.new(img_path).last
    @brightness_map = calc_chars_brightness
    @terminal_width = `tput cols`.strip.to_i
    @color = color == '--with-color' ? true : false
  end

  def start
    # Shrink img to terminal width
    shrink_times = (@img.columns.to_f / @terminal_width).ceil
    preprocessed_img = @img.resize(@img.columns / shrink_times, @img.rows / shrink_times / 2)

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

  def terminal_width
    cols = `tput cols`.strip.to_i
  end

  def normalize(brightness, max_brightness, min_brightness)
    255 * (brightness - min_brightness) / (max_brightness - min_brightness)
  end

  def brightness(pixel)
    Math.sqrt(
      0.299 * pixel.red**2 +
      0.587 * pixel.green**2 +
      0.114 * pixel.blue**2
    ).to_i
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
  
  def calc_chars_brightness
    brightness_map = ALLOW_CHARS.map do |char|
      # Empty img
      tmp_img = Image.new(15, 15) { |img| img.background_color = 'black' }

      # Draw char on empty img
      drawing = Draw.new do |text|
        text.pointsize = 12
        text.fill = '#ffffff'
        text.font = 'Courier'
        text.gravity = NorthWestGravity
      end
      drawing.annotate(tmp_img, 0, 0, 0, 0, char) 

      # Calculate brightness of a char
      total_brightness = 0
      count = 0
      tmp_img.each_pixel do |p|
        total_brightness += brightness(p)
        count += 1
      end
      avg_brightness_of_char = total_brightness / count
      { char => avg_brightness_of_char }
    end.reduce {|a, b| a.merge(b)}

    # Normalize the brightness to 0 ~ 255
    brightness_map.map do |k, v|
      new_value = 255 * (v - brightness_map.values.min) / (brightness_map.values.max - brightness_map.values.min)
      { k => new_value }
    end.reduce {|a, b| a.merge(b)}
  end
end

image_path = ARGV[0]
color = ARGV[1] || false
puts(Textify.new(image_path, color).start)
