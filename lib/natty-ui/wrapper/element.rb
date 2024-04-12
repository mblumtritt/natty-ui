# frozen_string_literal: true

require_relative '../features'

module NattyUI
  class Wrapper
    #
    # Basic visual element implementing all {Features}.
    #
    class Element
      include Features

      # @return [Section] when embedded in a section
      # @return [Wrapper] when not embedded in a section
      attr_reader :parent

      # @return [Symbol] close status when closed
      # @return [nil] when not closed
      attr_reader :status

      # @attribute [r] closed?
      # @return [Boolean] whether its closed or not
      def closed? = (@status != nil)

      # Close the element.
      #
      # @return [Element] itself
      def close = _close(:closed)

      alias _to_s to_s
      private :_to_s

      # @!visibility private
      def inspect = @status ? "#{_to_s[..-2]} status=#{@status}>" : _to_s

      protected

      def prefix = "#{@parent.__send__(:prefix)}#{@prefix}"
      def suffix = "#{@suffix}#{@parent.__send__(:suffix)}"
      def prefix_width = _blemish_width(prefix)
      def suffix_width = _blemish_width(suffix)
      def available_width = wrapper.screen_columns - prefix_width - suffix_width
      def finish = nil

      def wrapper
        return @wrapper if @wrapper
        @wrapper = self
        @wrapper = @wrapper.parent until @wrapper.is_a?(Wrapper)
        @wrapper
      end

      def initialize(parent, **_) = (@parent = parent)

      def _close(state)
        return self if @status
        @status = state
        finish
        @raise ? raise(BREAK) : self
      end

      def _call
        NattyUI.instance_variable_set(:@element, self)
        @raise = true
        yield(self)
        close unless closed?
      rescue BREAK
        nil
      ensure
        NattyUI.instance_variable_set(:@element, @parent)
      end

      BREAK = Class.new(StandardError)
      private_constant :BREAK

      private_class_method :new
    end
  end
end
