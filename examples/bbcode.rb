# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.h2 'NattyUI: BBCode-like Attribute Syntax', space: 2

ui.table type: :rows do |table|
  [
    %w[b bold],
    %w[faint],
    %w[i italic],
    %w[u underline],
    %w[uu double_underline],
    %w[cu curly_underline],
    %w[dau dashed_underline],
    %w[dou dotted_underline],
    %w[fraktur],
    %w[blink slow_blink],
    %w[inv invert],
    %w[h hide conceal],
    %w[strike],
    %w[framed],
    %w[encircled],
    %w[ovr overlined],
    %w[sub subscript],
    %w[sup superscript]
  ].each do |att|
    short = att[0]
    name = (att[1] || att[0]).tr('_', ' ').capitalize
    table.add(
      "[#{short}]#{name}[/#{short}]",
      att.map { "[\\#{_1}]...[\\/#{_1}]" }.join(' or ')
    )
  end
  table.align_column(0, :right)
end
ui.space
