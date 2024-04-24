# frozen_string_literal: true

require_relative '../lib/natty-ui'
# require 'natty-ui'

ui.space

ui.h1 'NattyUI Basic Feature Demo'
ui.puts <<~TEXT

  This is a short demo of the basic features of [[75 bold]]NattyUI[[/]].

TEXT

ui.h2 'Feature: ANSI Colors and Attributes'
ui.puts <<~TEXT

  Like you might noticed you can [[57]]color [[d7]]text[[/]] for terminals supporting this
  feature. You can enforece the non-ANSI version by setting the environment
  variable [[75 italic]]NO_COLOR[[/]] to '[[75]]1[[/]]'. (see also [[underline]]https://no-color.org[[/]])

  You can not only color your text but also [[italic]]modify[[/]], [[underline]]decorate[[/]] and [[strike]]manipulate[[/]]
  it. The attributes are direct embedded into the text like '[[/bold red]]'
  and can be reset with '[[//]]' or at the line end.

TEXT

ui.h2 'Feature: Sections'
ui.puts <<~TEXT

  Sections group text lines together and/or define their style. There are
  several section types which all can be stacked.

  Have a look at the different types of sections:

TEXT

ui.message 'Generic Message'

ui.information 'Informational Message'

ui.warning 'Warning Message'

ui.error 'Error Message'

ui.completed 'Completion Message'

ui.failed 'Failure Message'

ui.msg '[[d5]]Customized Message', glyph: '👻'

ui.space
ui.puts 'You can stack all kinds of sections together:'
ui.space

ui.framed do
  ui.framed type: :heavy do
    ui.framed type: :simple do
      ui.framed type: :double do
        ui.message('[[fff400]]Frames are nice', glyph: '💛')
      end
    end
  end
end
ui.space
