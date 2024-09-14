# frozen_string_literal: true

require 'just-ansi'

module NattyUI
  Ansi = JustAnsi

  module Ansi
    FRAME_COLOR = self[39].freeze
  end
end
