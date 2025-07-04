# frozen_string_literal: true

require_relative 'features'

module NattyUI
  # Base element class supporting all {Features}.
  #
  class Element
    include Features

    # @!visibility private
    def columns = @parent.columns - @prefix_width - @suffix_width

    # @!visibility private
    def puts(*objects, **options)
      if @prefix
        options[:prefix] = "#{@prefix}#{options[:prefix]}"
        options[:prefix_width] = options[:prefix_width].to_i + @prefix_width
        if (first_line = options[:first_line_prefix])
          options[:first_line_prefix] = "#{@prefix}#{first_line}"
          if (flw = options[:first_line_prefix_width])
            options[:first_line_prefix_width] = flw + @prefix_width
          end
        end
      end
      if @suffix
        options[:suffix] = "#{options[:suffix]}#{@suffix}"
        options[:suffix_width] = options[:suffix_width].to_i + @suffix_width
      end
      # options[:max_width] = @max_width if @max_width
      @parent.puts(*objects, **options)
      self
    end

    alias _to_s to_s

    # @!visibility private
    alias to_s inspect
    private :_to_s

    private

    def initialize(parent)
      @parent = parent
      @prefix_width = @suffix_width = 0
    end
  end

  module StateMixin
    attr_reader :state

    def closed? = @state ? true : false
    def ok? = @state == :ok
    def failed? = @state == :failed

    # @return [Element] itself
    def done(*text) = @state ? self : finish_ok(text)
    alias ok done

    # @!visibility private
    def failed(title, *msg)
      return if @state
      super
      finish_failed
    end

    # @!visibility private
    def inspect = "#{_to_s.chop} state=#{@state.inspect}>"

    protected

    def finish_failed
      @state = :failed
      self
    end
  end
  private_constant :StateMixin
end
