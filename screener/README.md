# Screener

A ruby library for formating the output of terminal.

### Screenshot

![example](https://github.com/shrimp509/terminal-games/blob/main/screenshots/screener-example.gif)

### Usage

```ruby
require './screener'

Screener.print_to_center("HELLO WORLD")
sleep(1)
Screener.print_to_center("山姆怎麼那麼帥")
sleep(1)
Screener.print_to_center("Hello 山姆超帥的喲喲喲喲喲喲喲喲喲喲")
sleep(1)
Screener.clear_n2_top
Screener.lottery(['山姆老弟，我最希換', '山姆最棒', '你是我的最愛', '嗨嗨嗨', '帥哥你好'])
```