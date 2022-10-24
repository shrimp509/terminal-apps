require 'rmagick'
include Magick

class Textify

  ALLOW_CHARS = '~!@#$%^&*()_+{}:">?`1234567890-=[];\',.'.chars.append(('a'..'z').to_a).append(('A'..'Z').to_a).flatten

  def initialize(img_path)
    @img = ImageList.new(img_path).last
    @brightness_map = calc_chars_brightness
    @terminal_width = `tput cols`.strip.to_i
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
    
    # Normalize brightness
    normalized_brightness = []
    preprocessed_img.each_pixel do |pixel, column, row|
      normalized_brightness.append(
        normalize(brightness(pixel), brightness_array.max, brightness_array.min)
      )
    end

    result = ''
    counter = 0
    normalized_brightness.map do |pixel_brightness|
      result += "\n" if counter % preprocessed_img.columns == 0
      result += find_best_char(pixel_brightness)
      counter += 1
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
puts(Textify.new(image_path).start)
