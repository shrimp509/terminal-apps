require './colorful.rb'

puts("Something good news.".green)
puts("Something needs warning.".yellow)
puts("Something needs error.".red)
puts("You can add text color and background color at the same time.".red.bg_white)
puts("But, you cannot #{'mix together'.red.bg_yellow} in the middle currently.".green)
puts("So instead, you shold ".green + "manually divide".red.bg_yellow + " them.".green)