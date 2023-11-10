# frozen_string_literal: true

module NattyUI
  #
  # Mix-in for output functionality.
  #
  module Features
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
