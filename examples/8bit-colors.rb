# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h1 'NattyUI: 8-bit Color Support', space: 2

color = ->(i) { "[bg#{i = i.to_s(16).rjust(2, '0')}] #{i} " }
cube =
  proc do |start|
    start
      .step(start + 185, by: 36)
      .map { |i| i.upto(i + 5).map(&color).join }
      .unshift('6x6 Color Cube')
      .join("\n")
  end

ui.columns do |cc|
  cc.add(
    <<~COLORS,
      System Colors
      [#ff]#{0.upto(7).map(&color).join}
      [#00]#{8.upto(0xf).map(&color).join}
    COLORS
    min_width: 32,
    width: :max,
    align: :center,
    padding: [0, 2, 1, 1]
  )

  cc.add(
    <<~GRAYSCALE,
      Grayscale
      [#ff]#{0xe8.upto(0xf3).map(&color).join}
      [#ff]#{0xf4.upto(0xff).map(&color).join}
    GRAYSCALE
    min_width: 48,
    width: :max,
    align: :center,
    padding: [0, 2, 1, 1]
  )
end

ui.columns do |cc|
  cc.add_many(
    *0x10.step(0x2e, by: 6).map(&cube),
    min_width: 24,
    width: :max,
    align: :center,
    padding: [0, 2, 1, 1]
  )
end
