# frozen_string_literal: true

module NattyUI
  #
  # Features of {NattyUI} - methods to display natty elements.
  #
  module Features
    # Print a horizontal rule
    #
    # @param [#to_s] symbol string to build the horizontal rule
    # @return [Wrapper, Wrapper::Element] itself
    def hr(symbol = '═')
      symbol = symbol.to_s
      size = _cleared_width(symbol)
      return self if size.zero?
      msg = symbol * ((available_width - 1) / size)
      puts(msg, prefix: Ansi[39], suffix: Ansi::RESET)
    end

    protected

    def _cleared(str) = Ansi.blemish(NattyUI.plain(str))
    def _cleared_width(str) = NattyUI.display_width(_cleared(str))

    def _element(type, ...)
      wrapper.class.const_get(type).__send__(:new, self).__send__(:_call, ...)
    end

    def _section(owner, type, args, **opts, &block)
      sec = wrapper.class.const_get(type).__send__(:new, owner, **opts)
      sec.puts(*args) if args && !args.empty?
      block ? sec.__send__(:_call, &block) : sec
    end
  end
end
