# frozen_string_literal: true

require_relative 'wrapper'

module NattyUI
  class AnsiWrapper < Wrapper
    def ansi? = true

    def cursor=(value)
      if value
        (@stream << Ansi::CURSOR_SHOW).flush if @cursor == 1
        @cursor -= 1 if @cursor.positive?
        return
      end
      (@stream << Ansi::CURSOR_HIDE).flush if @cursor == 0
      @cursor += 1
    end

    def puts(*args, **kwargs)
      return super if args.empty? || (animation = kwargs[:animation]).nil?
      animation = Animation[animation].new(wrapper, args, kwargs)
      self.cursor = false
      animation.perform(@stream)
      @lines_written += animation.lines_written
      self.cursor = true
      self
    end

    def page
      unless block_given?
        @stream.flush
        return self
      end
      (@stream << Ansi::SCREEN_BLANK).flush
      begin
        yield(self)
      ensure
        (@stream << Ansi::SCREEN_UNBLANK).flush
      end
    end

    def cls
      (@stream << Ansi::CLS).flush
      self
    end

    protected

    def pprint(strs, opts)
      prefix = opts[:prefix] and prefix = Text.embellish(prefix)
      suffix = opts[:suffix] and suffix = Text.embellish(suffix)
      return yield("#{prefix}#{suffix}") if strs.empty?
      embellish = opts[:embellish] != :skip
      max_width =
        opts.fetch(:max_width) do
          screen_columns - (opts[:prefix_width] || Text.width(prefix)) -
            (opts[:suffix_width] || Text.width(suffix))
        end
      case opts[:align]
      when :right
        Text.each_line(strs, max_width, embellish) do |line, width|
          width = max_width - width
          yield("#{prefix}#{' ' * width}#{line}#{suffix}")
        end
      when :center
        Text.each_line(strs, max_width, embellish) do |line, width|
          width = max_width - width
          right = width / 2
          yield(
            "#{prefix}#{' ' * (width - right)}#{line}#{' ' * right}#{suffix}"
          )
        end
      else
        Text.each_line(strs, max_width, embellish) do |line|
          yield("#{prefix}#{line}#{suffix}")
        end
      end
    end

    def temp_func
      count = @lines_written
      lambda do
        if (c = @lines_written - count).nonzero?
          @stream << Ansi.cursor_prev_line(c) << Ansi.screen_erase(:below) <<
            Ansi::CURSOR_FIRST_COLUMN
          @lines_written -= c
        end
        @stream.flush
        self
      end
    end

    class Progress < Element
      include ProgressAttributes
      include ValueAttributes

      protected

      def call(title, max_value, spinner)
        @title = "[b 27]➔[/b] #{title}"
        @info = nil
        @final_text = [title]
        if max_value
          @max_value = [0, max_value.to_f].max
        else
          @spinner = NattyUI::Spinner[spinner]
        end
        @value = 0
        @pos = wrapper.lines_written
        wrapper.cursor = false
        @parent.puts(@last_render = render)
        @height = wrapper.lines_written - @pos
        self
      end

      def redraw
        return if @status
        current = render
        return if @last_render == current
        wrapper.stream << Ansi.cursor_previous_line(@height) << Ansi::LINE_ERASE
        cl = wrapper.lines_written
        @parent.puts(@last_render = current)
        @height = wrapper.lines_written - cl
      end

      def render
        return "#{@title} #{@spinner.next}#{" #{@info}" if @info}" if @spinner
        percent = @max_value == 0 ? 100.0 : @value / @max_value
        count = [(30 * percent).round, 30].min
        mv = @max_value.round.to_s
        "#{@title} [27 on27]#{'█' * count}[ec onec]#{
          '▁' * (30 - count)
        }[/bg] [e2 b]#{(percent * 100).round.to_s.rjust(3)}%[/b] [f6](#{
          @value.round.to_s.rjust(mv.size)
        }/#{mv})[/]#{" #{@info}" if @info}"
      end

      def finish
        wrapper.stream << Ansi.cursor_previous_line(@height) << Ansi::LINE_ERASE
        wrapper.instance_variable_set(:@lines_written, @pos)
        wrapper.cursor = true
        return @parent.failed(*@final_text) if failed?
        @parent.message(*@final_text, glyph: @status = :completed)
      end
    end

    module Temporary
      def temporary
        unless block_given?
          wrapper.stream.flush
          return self
        end
        count = wrapper.lines_written
        begin
          yield(self)
        ensure
          count = wrapper.lines_written - count
          if count.nonzero?
            wrapper.stream << Ansi.cursor_prev_line(count) <<
              Ansi.display(:erase_below)
          end
          wrapper.stream.flush
        end
      end
    end

    class Section < Section
      include Temporary
    end

    class Quote < Quote
      include Temporary

      def initialize(...)
        super
        @prefix = "#{Ansi::FRAME_COLOR}#{@prefix}#{Ansi::RESET}"
      end
    end

    class Framed < Framed
      protected

      def init(title, type)
        @prefix = "#{col = "[27]#{type[4]}[/]"}#{' ' * @pl}"
        @suffix = "#{Ansi.cursor_column(@parent.rcol)}#{col}"

        width = parent.available_width - 2
        @finish = "[27]#{type[2]}#{type[5] * width}#{type[3]}"

        parent.puts(
          if title
            "[27]#{type[0]}#{type[5]}#{type[10]}[/]#{title}[27]#{type[9]}#{
              type[5] * (width - 3 - Text.width(title))
            }#{type[1]}"
          else
            "[27]#{type[0]}#{type[5] * width}#{type[1]}"
          end
        )
      end
    end

    class Message < Section
      protected

      def initialize(parent, title:, glyph:, **opts)
        color = COLORS[glyph] || COLORS[:default]
        glyph = NattyUI::Glyph[glyph]
        prefix_width = Text.width(glyph) + 1
        parent.puts(
          title,
          prefix: "#{glyph} #{color}",
          prefix_width: prefix_width,
          suffix: Ansi::RESET,
          suffix_width: 0
        )
        super(
          parent,
          prefix: ' ' * prefix_width,
          prefix_width: prefix_width,
          **opts
        )
      end

      white = Ansi[255]
      COLORS = {
        default: white,
        point: white,
        information: white,
        warning: Ansi[221],
        error: Ansi[208],
        completed: Ansi[82],
        failed: Ansi[196],
        task: Ansi[39],
        query: white
      }.compare_by_identity.freeze
    end

    class Task < Message
      include ProgressAttributes
      include TaskMethods
    end
  end

  private_constant :AnsiWrapper
end
