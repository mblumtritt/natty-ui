# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Wrapper
    class Query < Element
      protected

      def _call(question, choices, kw_choices, result_typye)
        choices = grab(choices, kw_choices)
        return if choices.empty?
        wrapper.temporary do
          query(question, choices)
          read_(choices, result_typye)
        end
      end

      def query(question, choices)
        __section(
          @parent,
          :Message,
          choices.map { |k, v| "#{k} #{v}" },
          title: question,
          symbol: '▶︎'
        )
      end

      def read_(choices, result_typye)
        while true
          char = NattyUI.in_stream.getch
          return if "\3\4\e".include?(char)
          next unless choices.key?(char)
          return char if result_typye == :char
          return choices[char] if result_typye == :choice
          return char, choices[char]
        end
      end

      def grab(choices, kw_choices)
        Array
          .new(choices.size) { |i| i + 1 }
          .zip(choices)
          .to_h
          .merge!(kw_choices)
          .transform_keys! { |k| [k.to_s[0], ' '].max }
          .transform_values! { |v| v.to_s.tr("\r\n", ' ') }
      end
    end

    private_constant :Query
  end
end
