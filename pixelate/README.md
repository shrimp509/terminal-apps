# Pixelate

A simple command line tool for pixelating a image based on `ImageMagick`.

### Screenshot

![](https://github.com/shrimp509/terminal-games/blob/main/screenshots/pixelate-example.png)

### Prerequisites

1. Install [ImageMagick](https://imagemagick.org/index.php) (A famous image processing library) please before you using this tool.

    * For mac: `$ brew install pkg-config imagemagick`

2. Install [RMagick](https://github.com/rmagick/rmagick) (A ruby bindings for ImageMagick) please before you using this tool.

    * `$ gem install rmagick`

### Usage

1. Start pixelate with an example image as input: `$ ruby pixelated.rb examples/cat.jpeg`
2. Check the output image in the same directory of input image. (e.g. `examples/cat-pixelated.jpeg`)