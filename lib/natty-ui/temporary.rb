# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # Temprary display section used by
  # {Features.temporary}.
  #
  class Temporary < Element
    # @!visibility private
    def puts(*objects, **opts)
      return self if @state
      if opts.delete(:pin)
        (@pins ||= []) << [objects, opts.except(:prefix_width, :suffix_width)]
      end
      super
    end

    # @!visibility private
    def done
      return self if @state
      NattyUI.back_to_line(@start_line) if @start_line
      @pins&.each { |objects, opts| puts(*objects, **opts) }
      @state = :ok
      self
    end

    private

    def initialize(parent)
      @start_line = NattyUI.lines_written
      super
    end
  end
end
