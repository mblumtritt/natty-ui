# frozen_string_literal: true

require_relative 'element'

module NattyUI
  class Wrapper
    class Ask < Element
      protected

      def _call(question, yes, no)
        yes, no = grab(yes, no)
        query(question)
        ret = read(yes, no)
        finish
        ret
      end

      def query(question)
        (wrapper.stream << prefix << "▶︎ #{question} ").flush
      end

      def finish = (wrapper.stream << "\n").flush

      def read(yes, no)
        while true
          char = NattyUI.in_stream.getch
          return if "\u0003\u0004\e".include?(char)
          return true if yes.include?(char)
          return false if no.include?(char)
        end
      end

      def grab(yes, no)
        yes = yes.to_s.chars.uniq
        no = no.to_s.chars.uniq
        raise(ArgumentError, ':yes can not be emoty') if yes.empty?
        raise(ArgumentError, ':no can not be emoty') if no.empty?
        return yes, no if (yes & no).empty?
        raise(ArgumentError, 'chars in :yes and :no can not be intersect')
      end
    end

    private_constant :Ask
  end
end
