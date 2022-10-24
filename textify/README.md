# Textify

A simple command line tool for turning image to ascii text.

### Screenshot

![](https://github.com/shrimp509/terminal-games/blob/main/screenshots/textify-example.png)

### Prerequisites

1. Install [ImageMagick](https://imagemagick.org/index.php) (A famous image processing library) please before you using this tool.

    * For mac: `$ brew install pkg-config imagemagick`

2. Install [RMagick](https://github.com/rmagick/rmagick) (A ruby bindings for ImageMagick) please before you using this tool.

    * `$ gem install rmagick`

### Usage

1. Start textify with an example image as input: `$ ruby textify.rb examples/cat.jpeg`
2. Check the text output at terminal.

### Options

1. `--with-color`: output with terminal colors

    e.g. `$ ruby textify.rb examples/cat.jpeg --with-color`

    ![](https://github.com/shrimp509/terminal-games/blob/main/screenshots/textify-with-color-example.png)
