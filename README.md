# NattyUI ![version](https://img.shields.io/gem/v/natty-ui?label=)

This is the beautiful, nice, nifty, fancy, neat, pretty, cool, lovely, natty user interface you like to have for your command line interfaces (CLI).

- Gem: [rubygems.org](https://rubygems.org/gems/natty-ui)
- Source: [github.com](https://github.com/mblumtritt/natty-ui)
- Help: [rubydoc.info](https://rubydoc.info/gems/natty-ui/NattyUI)

## Description

Here you find elegant, simple and beautiful tools that enhance your command line application functionally and look.

You can simply decorate your text with named ANSI attributes and colors

```ruby
UI = NattyUI::StdOut

UI.puts "[[bold]]Hello [[ff7bfd]]World[[/]]!"
```

or use different types of messages

```ruby
UI.info 'NattyUI installed'
UI.warning 'Nice gem found!'
```

and headings

```ruby
UI.h1 'The Main Title (TMT)'
UI.h2 'A Subtitle'
```

and framed sections

```ruby
UI.framed 'Text Below In Frame' do |framed|
  framed.puts 'This is the text'
end
```

or use progression displays like progress bars.

🚀 There are much more [features](https://rubydoc.info/gems/natty-ui/NattyUI/Features)!

📕 See the [online help](https://rubydoc.info/gems/natty-ui/NattyUI) for more details or have a look at the [examples](./examples/) directory to get an impression of the current feature set.

![illustration](https://raw.githubusercontent.com/mblumtritt/natty-ui/main/examples/illustration.png)

## Installation

You can install the gem in your system with

```shell
gem install natty-ui
```

or you can use [Bundler](http://gembundler.com/) to add NattyUI to your own project:

```shell
bundle add 'natty-ui'
```

After that you only need one line of code to have everything together

```ruby
require 'natty-ui'
```

## Run Examples

You can execute the examples by

```sh
ruby ./examples/basic.rb
```

or see the non-ANSI version

```sh
NO_COLOR=1 ruby ./examples/basic.rb
```

## NO_COLOR Convention

NattyUI follows the [NO_COLOR convention](https://no-color.org).

## TODO

Since I did not complete the tests and not all my ideas are already implemented I have this Todo list:

- add more samples to help
- add more tests
- simple prompt
- password prompt
