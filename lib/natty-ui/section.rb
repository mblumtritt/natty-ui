# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # {Element} implemting a display section used by
  #
  # - {Features.section}
  # - {Features.message}
  # - {Features.information}
  # - {Features.warning}
  # - {Features.error}
  # - {Features.failed}
  #
  class Section < Element
    include StateMixin

    # @!visibility private
    def puts(*objects, **options) = @state ? self : super

    private

    def finish_ok(text)
      puts(*text) unless text.empty?
      @state = :ok
      @parent.puts(@border.bottom)
      self
    end

    def finish_failed
      @parent.puts(@border.bottom)
      super
    end

    def show_title(title)
      return @parent.puts(@border.top) unless title
      prefix = @border.top_left
      suffix = @border.top_right
      @parent.puts(
        title,
        prefix: prefix,
        prefix_width: prefix.width,
        suffix: suffix,
        suffix_width: suffix.width
      )
    end

    def initialize(parent, title, msg, kind)
      super(parent)
      title, rest = split(title) if title && !title.empty?
      @border = Theme.current.section_border(kind)
      show_title(title)
      @prefix = @border.prefix
      @prefix_width = @prefix.size
      puts(*rest) if rest && !rest.empty?
      puts(*msg) unless msg.empty?
    end

    def split(title)
      rest =
        Text.each_line(
          title,
          limit: @parent.columns - 9,
          ansi: Terminal.ansi?
        ).to_a
      [rest.shift, rest]
    end
  end
end
