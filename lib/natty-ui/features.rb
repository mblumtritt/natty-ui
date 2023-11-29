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
      size = _plain_width(symbol)
      return self if size.zero?
      msg = symbol * ((available_width - 1) / size)
      return puts(msg, prefix: Ansi[39], suffix: Ansi.reset) if wrapper.ansi?
      puts(msg)
    end

    protected

    def _plain_width(str) = NattyUI.display_width(NattyUI.plain(str))
    def _blemish_width(str) = NattyUI.display_width(Ansi.blemish(str))

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
