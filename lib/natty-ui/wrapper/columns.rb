# frozen_string_literal: true

require_relative 'helpers'
require_relative 'element'

module NattyUI
  module Features
    #
    # Generate a column view.
    #
    # @see Cell#initialize
    #
    # @param texts [Array<#to_s>] texts to create cells
    # @param options (see Cell#initialize)
    # @yieldparam columns [Columns] construction helper
    # @return [Wrapper::Section, Wrapper] it's parent object
    def columns(*texts, **options)
      columns = Columns.create(*texts, **options)
      yield(columns) if block_given?
      (columns = columns.to_a).empty? ? self : _element(:Columns, columns)
    end
  end

  class Wrapper
    # An {Element} to print columns.
    #
    # @see Features#columns
    class Columns < Element
      protected

      def call(columns)
        @parent.puts(
          Render::Columns.new(available_width, columns),
          embellish: :skip
        )
      end
    end
  end
end
