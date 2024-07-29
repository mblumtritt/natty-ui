# frozen_string_literal: true

require_relative 'features'

module NattyUI
  class Wrapper
    #
    # Basic visual element.
    #
    class Element
      include Features

      # @attribute [r] available_width
      # @return [Integer] available columns count within the element
      def available_width = @parent.available_width

      # @attribute [r] closed?
      # @return [Boolean] whether its closed or not
      def closed? = (@status != nil)

      # @return [Section, Wrapper] parent element
      attr_reader :parent

      # @return [Symbol, nil] status when closed
      attr_reader :status

      # @attribute [r] wrapper
      # @return [Wrapper] assigned output stream wrapper
      def wrapper
        return @wrapper if @wrapper
        @wrapper = @parent
        @wrapper = @wrapper.parent until @wrapper.is_a?(Wrapper)
        @wrapper
      end

      # Close the element.
      #
      # @return [Element] itself
      def close = _close(:closed)

      alias _to_s to_s
      private :_to_s
      # @!visibility private
      def inspect = _to_s

      protected

      def _close(state)
        return self if @status
        @status = state
        finish
        @raise ? raise(BREAK) : self
      end

      def call
        NattyUI.instance_variable_set(:@element, self)
        @raise = true
        yield(self)
        closed? ? self : close
      rescue BREAK
        nil
      ensure
        NattyUI.instance_variable_set(:@element, @parent)
      end

      def finish = nil
      def prefix = "#{@parent.instance_variable_get(:@prefix)}#{@prefix}"

      def initialize(parent)
        @parent = parent
      end

      private_class_method :new

      BREAK = Class.new(StandardError)
      private_constant :BREAK
    end
  end
end
