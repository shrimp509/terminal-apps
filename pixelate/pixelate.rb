require 'rmagick'
include Magick

class Pixelater
  def self.start(path)
    parent = File.dirname(path)
    extname = File.extname(path)
    filename = File.basename(path, extname)
    save_as_path = "#{parent}/#{filename}-pixelated#{extname}"
    response = ImageList.new(path).quantize(8).montage.magnify.magnify.magnify.write(save_as_path)
    return '像素化成功' if response
  rescue => e
    return '像素化失敗！'
  end
end

def output_format(msg)
  msg
end

log = '/Users/unclesam/Downloads/log.txt'

puts(ARGV[0])
output = Pixelater.start(ARGV[0])
puts(output)

File.open(log, 'a') {|f| f.write("#{Time.now}: #{output}\n")}
