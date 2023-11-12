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
      size = NattyUI.display_width(NattyUI.plain(symbol.to_s))
      return self if size.zero?
      puts(
        symbol * (available_width / size),
        prefix: Ansi[39],
        suffix: Ansi.reset
      )
    end

    protected

    def _element(type, *args)
      wrapper.class.const_get(type).__send__(:new, self).__send__(:_call, *args)
    end

    def _section(owner, type, args, **opts, &block)
      sec = wrapper.class.const_get(type).__send__(:new, owner, **opts)
      sec.puts(*args) if args && !args.empty?
      block ? sec.__send__(:_call, &block) : sec
    end
  end
end
