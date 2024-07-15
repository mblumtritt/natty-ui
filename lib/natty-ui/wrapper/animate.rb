# frozen_string_literal: true

module NattyUI
  module Features
    # Print given arguments line-wise with animation.
    #
    # @overload animate(..., animation: :default)
    #   @param [#to_s] ... objects to print
    #   @param [:binary, :default, :matrix, :rainbow, :type_writer]
    #     animation type of animation
    #   @return [Wrapper::Section, Wrapper] it's parent object
    def animate(*args, **kwargs)
      kwargs[:animation] ||= :default
      puts(*args, **kwargs)
    end
  end
end
