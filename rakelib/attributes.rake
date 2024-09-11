# frozen_string_literal: true

desc 'Build ANSI attributes file'
task 'build:ansi' => 'lib/natty-ui/ansi/attributes.rb'

desc 'Remove ANSI attributes file'
task 'clobber:ansi' do
  Rake::Cleaner.cleanup_files(['lib/natty-ui/ansi/attributes.rb'])
end

directory 'lib/natty-ui/ansi'

file 'lib/natty-ui/ansi/attributes.rb' => 'lib/natty-ui/ansi' do |f|
  generate(f.name, AttributesGen.generate)
end

module AttributesGen
  def self.generate
    <<~RUBY
      # frozen_string_literal: true

      module NattyUI
        module Ansi
          ATTRIBUTES = {
      #{from attributes}
          }.freeze

          ATTRIBUTES_S =
            ATTRIBUTES.transform_keys(&:to_sym).compare_by_identity.freeze

          COLORS = {
      #{from colors}
          }.freeze

          COLORS_S = COLORS.transform_keys(&:to_sym).compare_by_identity.freeze

          private_constant(:ATTRIBUTES, :ATTRIBUTES_S, :COLORS, :COLORS_S)
        end
      end
    RUBY
  end

  def self.from(map)
    map
      .keys
      .sort!
      .map! { |name| "      '#{name}' => '#{map[name]}'" }
      .join(",\n")
  end

  def self.attributes
    map = {
      'reset' => '',
      # "new underline"
      'curly_underline_off' => '4:0',
      # 'underline' => '4:1',
      # 'double_underline' => '4:2',
      'curly_underline' => '4:3',
      'dotted_underline' => '4:4',
      'dashed_underline' => '4:5'
    }

    add = ->(s, n) { n.each_with_index { |a, idx| map[a] = s + idx } }

    add[
      1,
      %w[
        bold
        faint
        italic
        underline
        blink
        rapid_blink
        invert
        hide
        strike
        primary_font
        font1
        font2
        font3
        font4
        font5
        font6
        font7
        font8
        font9
        fraktur
        double_underline
        bold_off
        italic_off
        underline_off
        blink_off
        proportional
        invert_off
        hide_off
        strike_off
      ]
    ]
    add[
      50,
      %w[proportional_off framed encircled overlined framed_off overlined_off]
    ]
    add[73, %w[superscript subscript superscript_off]]

    map['dashed_underline_off'] = map['curly_underline_off']
    map['default_font'] = map['primary_font']
    map['dotted_underline_off'] = map['curly_underline_off']
    map['double_underline_off'] = map['underline_off']
    map['encircled_off'] = map['framed_off']
    map['faint_off'] = map['bold_off']
    map['fraktur_off'] = map['italic_off']
    map['reveal'] = map['hide_off']
    map['subscript_off'] = map['superscript_off']

    add_alias =
      proc do |name, org_name|
        map[name] = map[org_name]
        map["/#{name}"] = map["#{org_name}_off"]
      end

    add_alias['b', 'bold']
    add_alias['conceal', 'hide']
    add_alias['cu', 'curly_underline']
    add_alias['dau', 'dashed_underline']
    add_alias['dim', 'faint']
    add_alias['dou', 'dotted_underline']
    add_alias['h', 'hide']
    add_alias['i', 'italic']
    add_alias['inv', 'invert']
    add_alias['ovr', 'overlined']
    add_alias['slow_blink', 'blink']
    add_alias['spacing', 'proportional']
    add_alias['sub', 'subscript']
    add_alias['sup', 'superscript']
    add_alias['u', 'underline']
    add_alias['uu', 'double_underline']

    map.merge!(
      map
        .filter_map do |name, att|
          ["/#{name.delete_suffix('_off')}", att] if name.end_with?('_off')
        end
        .to_h
    )
  end

  def self.colors
    clr = {
      0 => 'black',
      1 => 'red',
      2 => 'green',
      3 => 'yellow',
      4 => 'blue',
      5 => 'magenta',
      6 => 'cyan',
      7 => 'white'
    }
    map = {}
    add = ->(s, p) { clr.each_pair { |i, n| map["#{p}#{n}"] = s + i } }
    ul = ->(r, g, b) { "58;2;#{r};#{g};#{b}" }
    add[30, nil]
    map['default'] = 39
    add[90, 'bright_']
    add[30, 'fg_']
    map['fg_default'] = 39
    map['/fg'] = 39
    add[90, 'fg_bright_']
    add[40, 'bg_']
    map['bg_default'] = 49
    map['/bg'] = 49
    add[100, 'bg_bright_']
    add[40, 'on_']
    map['on_default'] = 49
    add[100, 'on_bright_']
    map.merge!(
      'ul_black' => ul[0, 0, 0],
      'ul_red' => ul[128, 0, 0],
      'ul_green' => ul[0, 128, 0],
      'ul_yellow' => ul[128, 128, 0],
      'ul_blue' => ul[0, 0, 128],
      'ul_magenta' => ul[128, 0, 128],
      'ul_cyan' => ul[0, 128, 128],
      'ul_white' => ul[128, 128, 128],
      'ul_default' => '59',
      '/ul' => '59',
      'ul_bright_black' => ul[64, 64, 64],
      'ul_bright_red' => ul[255, 0, 0],
      'ul_bright_green' => ul[0, 255, 0],
      'ul_bright_yellow' => ul[255, 255, 0],
      'ul_bright_blue' => ul[0, 0, 255],
      'ul_bright_magenta' => ul[255, 0, 255],
      'ul_bright_cyan' => ul[0, 255, 255],
      'ul_bright_white' => ul[255, 255, 255]
    )
  end
end
