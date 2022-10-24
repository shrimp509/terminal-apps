# Colorful

A ruby library for displaying colorful terminal output texts.

### Screenshot

![example](https://github.com/shrimp509/terminal-games/blob/main/screenshots/colorful-example.png)

### Usage

`$ ruby examples/hello-world.rb`

```ruby
require 'colorful'

puts("Something good news.".green)
puts("Something needs warning.".yellow)
puts("Something needs error.".red)
puts("You can add text color and background color at the same time.".red.bg_white)
puts("Also, you can mix together for highlighting #{'at the end.'.red.bg_yellow}".green)
puts("But, you cannot #{'mix together'.red.bg_yellow} in the middle currently.".green)
puts("So instead, you shold ".green + "manually divide".red.bg_yellow + " them.".green)
```