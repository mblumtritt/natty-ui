# frozen_string_literal: true

require_relative 'utils'

module NattyUI
  # @todo This chapter needs more documentation.
  #
  # A theme defines the style of elements.
  #
  class Theme
    class << self
      # Currently used theme
      #
      # @return [Compiled]
      attr_reader :current

      # @attribute [w] current
      def current=(value)
        case value
        when Theme::Compiled
          @current = value
        when Theme
          @current = value.compiled
        else
          raise(TypeError, 'Theme expected')
        end
      end

      # Create a theme.
      #
      # @return [Theme] new theme
      def create
        theme = new
        yield(theme) if block_given?
        theme
      end

      # Default theme.
      #
      # @attribute [r] default
      # @return [Theme] default theme
      def default
        create do |theme|
          theme.heading_sytle = :bright_blue
          theme.task_style = %i[bright_green b]
          # theme.choice_style =
          theme.choice_current_style = %i[bright_white on_blue b]
          theme.define_marker(
            bullet: '[bright_white]•[/fg]',
            checkmark: '[bright_green]✓[/fg]',
            quote: '[bright_blue]▍[/fg]',
            information: '[bright_yellow]𝒊[/fg]',
            warning: '[bright_yellow]![/fg]',
            error: '[red]𝙓[/fg]',
            failed: '[bright_red]𝑭[/fg]',
            current: '[bright_green]➔[/fg]',
            choice: '[bright_white]◦[/fg]',
            current_choice: '[bright_green]◉[/fg]'
          )
          theme.define_section(
            default: :bright_blue,
            message: :bright_blue,
            information: :bright_blue,
            warning: :bright_yellow,
            error: :red,
            failed: :bright_red
          )
        end
      end

      def emoji
        create do |theme|
          theme.heading_sytle = :bright_blue
          theme.task_style = %i[bright_green b]
          # theme.choice_style =
          theme.choice_current_style = %i[bright_white on_blue b]
          theme.define_marker(
            bullet: '▫️',
            checkmark: '✅',
            quote: '[bright_blue]▍[/fg]',
            information: '📌',
            warning: '⚠️',
            error: '❗️',
            failed: '‼️',
            current: '➡️',
            choice: '[bright_white]•[/fg]',
            current_choice: '[bright_green]●[/fg]'
          )
          theme.define_section(
            default: :bright_blue,
            message: :bright_blue,
            information: :bright_blue,
            warning: :bright_yellow,
            error: :red,
            failed: :bright_red
          )
        end
      end
    end

    attr_accessor :section_border
    attr_reader :mark,
                :border,
                :heading,
                :heading_sytle,
                :section_styles,
                :task_style,
                :choice_current_style,
                :choice_style

    def heading_sytle=(value)
      @heading_sytle = Utils.style(value)
    end

    def task_style=(value)
      @task_style = Utils.style(value)
    end

    def choice_current_style=(value)
      @choice_current_style = Utils.style(value)
    end

    def choice_style=(value)
      @choice_style = Utils.style(value)
    end

    def compiled = Compiled.new(self).freeze

    def define_marker(**defs)
      @mark.merge!(defs)
      self
    end

    def define_border(**defs)
      defs.each_pair do |name, str|
        s = str.to_s
        case Text.width(s, bbcode: false)
        when 1
          @border[name.to_sym] = "#{s * 11}  "
        when 11
          @border[name.to_sym] = "#{s}  "
        when 13
          @border[name.to_sym] = s
        else
          raise(
            TypeError,
            "invalid boder definition for #{name} - #{str.inspect}"
          )
        end
      end
      self
    end

    def define_heading(*defs)
      @heading = defs.flatten.take(6)
      @heading += Array.new(6 - @heading.size, @heading[-1])
      self
    end

    def define_section(**defs)
      defs.each_pair do |name, style|
        style = Utils.style(style)
        @section_styles[name.to_sym] = style if style
      end
      self
    end

    class Compiled
      attr_reader :task_style, :choice_current_style, :choice_style

      def defined_marks = @mark.keys.sort!
      def defined_borders = @border.keys.sort!

      def heading(index) = @heading[index.to_i.clamp(1, 6) - 1]

      def mark(value)
        return @mark[value] if value.is_a?(Symbol)
        (element = Str.new(value, true)).empty? ? @mark[:default] : element
      end

      def border(value)
        return @border[value] if value.is_a?(Symbol)
        case Text.width(value = value.to_s, bbcode: false)
        when 1
          "#{value * 11}  "
        when 11
          "#{value}  "
        when 13
          value
        else
          @border[:default]
        end
      end

      def section_border(kind)
        kind.is_a?(Symbol) ? @sections[kind] : @sections[:default]
      end

      def initialize(theme)
        @heading = create_heading(theme.heading, theme.heading_sytle).freeze
        @border = create_border(theme.border).freeze
        @mark = create_mark(theme.mark).freeze
        @task_style = as_style(theme.task_style)
        @choice_current_style = as_style(theme.choice_current_style)
        @choice_style = as_style(theme.choice_style)
        @sections =
          create_sections(
            SectionBorder.create(border(theme.section_border)),
            theme.section_styles.dup.compare_by_identity
          )
      end

      private

      def as_style(value) = (Ansi[*value].freeze if value)

      def create_sections(template, styles)
        Hash
          .new do |h, kind|
            h[kind] = SectionBorder.new(*template.parts(styles[kind])).freeze
          end
          .compare_by_identity
      end

      def create_mark(mark)
        return {} if mark.empty?
        with_default(mark.to_h { |n, e| [n.to_sym, Str.new("#{e} ")] })
      end

      def create_border(border)
        return {} if border.empty?
        with_default(border.transform_values { _1.dup.freeze })
      end

      def create_heading(heading, style)
        return create_styled_heading(heading, style) if style
        heading.map do |left|
          right = " #{left.reverse}"
          [left = Str.new("#{left} ", true), Str.new(right, left.size)]
        end
      end

      def create_styled_heading(heading, style)
        heading.map do |left|
          right = Ansi.decorate(left.reverse, *style)
          [
            left = Str.new("#{Ansi.decorate(left, *style)} ", true),
            Str.new(" #{right}", left.width)
          ]
        end
      end

      def with_default(map)
        map.default = (map[:default] ||= map[map.first.first])
        map.compare_by_identity
      end

      SectionBorder =
        Struct.new(:top, :top_left, :top_right, :bottom, :prefix) do
          def self.create(border)
            mid = border[10] * 2
            mid2 = mid * 2
            right = "#{border[11]}#{border[12] * 2}"
            new(
              border[0] + mid2 + right,
              border[0] + mid,
              mid + right,
              border[6] + mid2 + right,
              border[9]
            )
          end

          def parts(style)
            unless style
              return [
                Str.new(top, 6),
                Str.new("#{top_left} ", 4),
                Str.new(" #{top_right}", 6),
                Str.new(bottom, 6),
                Str.new("#{prefix} ", 2)
              ]
            end
            style = Ansi[*style]
            [
              # TODO: use rather [/fg]
              Str.new("#{style}#{top}#{Ansi::RESET}", 6),
              Str.new("#{style}#{top_left}#{Ansi::RESET} ", 4),
              Str.new(" #{style}#{top_right}#{Ansi::RESET}", 6),
              Str.new("#{style}#{bottom}#{Ansi::RESET}", 6),
              Str.new("#{style}#{prefix}#{Ansi::RESET} ", 2)
            ]
          end
        end

      private_constant :SectionBorder
    end

    private

    def initialize
      define_heading(%w[╸╸╺╸╺━━━ ╴╶╴╶─═══ ╴╶╴╶─── ════ ━━━━ ────])
      @mark = {
        default: '•',
        bullet: '•',
        checkmark: '✓',
        quote: '▍',
        information: '𝒊',
        warning: '!',
        error: '𝙓',
        failed: '𝑭',
        current: '➔',
        choice: '◦',
        current_choice: '◉'
      }
      @border = {
        ######### 0123456789012
        default: '┌┬┐├┼┤└┴┘│─╶╴',
        defaulth: '───────── ─╶╴',
        defaultv: '││││││││││ ',
        double: '╔╦╗╠╬╣╚╩╝║═',
        doubleh: '═════════ ═',
        doublev: '║║║║║║║║║║ ',
        heavy: '┏┳┓┣╋┫┗┻┛┃━╺╸',
        heavyh: '━━━━━━━━━ ━╺╸',
        heavyv: '┃┃┃┃┃┃┃┃┃┃ ',
        rounded: '╭┬╮├┼┤╰┴╯│─╶╴'
      }
      @section_border = :rounded
      @section_styles = {}
    end

    self.current = Terminal.colors == 2 ? new : default
  end
end
