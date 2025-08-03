# frozen_string_literal: true

require_relative 'element'

module NattyUI
  # Temprary display section used by
  # {Features.temporary}.
  #
  class Temporary < Element
    # @!visibility private
    def puts(*objects, **options)
      return self if @state
      if options.delete(:pin)
        @pins ||= []
        @pins << [objects, options.except(:prefix_width, :suffix_width)]
      end
      super
    end

    # @!visibility private
    def done
      return self if @state
      NattyUI.back_to_line(@start_line, erase: :all) if @start_line
      @pins&.each { |objects, options| puts(*objects, **options) }
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
