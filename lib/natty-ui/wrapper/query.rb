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
    # @param kw_choices [{Char => #to_s}] choices selectable with given char
    # @return [Char] when `result` is configured as `:char`
    # @return [#to_s] when `result` is configured as `:choice`
    # @return [[Char, #to_s]] when `result` is configured as `:both`
    # @return [nil] when input was aborted with `^C` or `^D`
    def query(question, *choices, result: :char, **kw_choices)
      _element(:Query, question, choices, kw_choices, result)
    end
  end

  class Wrapper
    #
    # An {Element} to request a user choice.
    #
    # @see Features#query
    class Query < Element
      protected

      def _call(question, choices, kw_choices, result_type)
        choices = grab(choices, kw_choices)
        return if choices.empty?
        wrapper.temporary do
          _section(
            @parent,
            :Message,
            choices.map { |k, v| "#{k} #{v}" },
            title: question,
            glyph: :query
          )
          read(choices, result_type)
        end
      end

      def read(choices, result_type)
        while true
          char = NattyUI.in_stream.getch
          return if "\3\4".include?(char)
          next unless choices.key?(char)
          return char if result_type == :char
          return choices[char] if result_type == :choice
          return char, choices[char]
        end
      end

      def grab(choices, kw_choices)
        Array
          .new(choices.size) { _1 + 1 }
          .zip(choices)
          .to_h
          .merge!(kw_choices)
          .transform_keys! { [' ', _1.to_s[0]].max }
          .transform_values! { _1.to_s.tr("\r\n\t", ' ') }
      end
    end
  end
end
