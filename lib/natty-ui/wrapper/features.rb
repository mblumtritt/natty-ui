# frozen_string_literal: true

module NattyUI
  #
  # Features of {NattyUI} - methods to display natty elements.
  #
  module Features
    protected

    def _element(type, ...)
      wrapper.class.const_get(type).__send__(:new, self).__send__(:call, ...)
    end

    def _section(type, args = nil, owner: nil, **opts, &block)
      sec = wrapper.class.const_get(type).__send__(:new, owner || self, **opts)
      sec.puts(*args) if args && !args.empty?
      sec.__send__(:call, &block) if block
      sec
    end
  end
end
