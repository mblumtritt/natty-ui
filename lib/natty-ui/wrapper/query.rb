# frozen_string_literal: true

require_relative 'element'

module NattyUI
  module Features
    # Request a choice from user.
    #
    # @example Select by Index
    #   choice = ui.query(
    #     'Which fruits do you prefer?',
    #     'Apples',
    #     'Bananas',
    #     'Cherries'
    #   )
    #   # => '1' or '2' or '3' or nil if user aborted
    #
    # @example Select by given char
    #   choice = ui.query(
    #     'Which fruits do you prefer?',
    #     a: 'Apples',
    #     b: 'Bananas',
    #     c: 'Cherries'
    #   )
    #   # => 'a' or 'b' or 'c' or nil if user aborted
    #
    # @see NattyUI.in_stream
    #
    # @param question [#to_s] Question to display
    # @param choices [#to_s] choices selectable via index (0..9)
    # @param result  [Symbol] defines how the result will be returned
    # @param display  [Symbol] display choices as `:list` or `:compact`
    # @param kw_choices [{Char => #to_s}] choices selectable with given char
    # @return [Char] when `result` is configured as `:char`
    # @return [#to_s] when `result` is configured as `:choice`
    # @return [[Char, #to_s]] when `result` is configured as `:both`
    # @return [nil] when input was aborted with `^C` or `^D`
    def query(question, *choices, result: :char, display: :list, **kw_choices)
      _element(:Query, question, choices, kw_choices, result, display)
    end
  end

  class Wrapper
    #
    # An {Element} to request a user choice.
    #
    # @see Features#query
    class Query < Element
      protected

      def call(question, choices, kw_choices, result, display)
        return if choices.empty? && kw_choices.empty?
        choices = as_choices(choices, kw_choices)
        text = choices.map { |k, v| "⦗#{CHOICE_MARK}#{k}#{Ansi::RESET}⦘ #{v}" }
        @parent.wrapper.temporary do
          if display == :compact
            @parent.msg(question, glyph: :query).ls(text)
          else
            @parent.msg(question, *text, glyph: :query)
          end
          read(choices, result)
        end
      end

      def as_choices(choices, kw_choices)
        choices
          .take(9)
          .each_with_index
          .to_h { |str, i| [i + 1, str] }
          .merge!(kw_choices)
          .transform_keys!(&:to_s)
          .transform_values! { _1.to_s.gsub(/[[:space:]]/, ' ') }
      end

      def read(choices, result)
        while true
          char = NattyUI.read_key
          return if char == 'Ctrl+C'
          next unless choices.key?(char)
          return char if result == :char
          return choices[char] if result == :title
          return char, choices[char]
        end
      end

      CHOICE_MARK = Ansi[:bold, 34]
      private_constant :CHOICE_MARK
    end
  end
end
