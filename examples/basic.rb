# frozen_string_literal: true

# require 'natty-ui'
require_relative '../lib/natty-ui'

UI = NattyUI::StdOut

UI.h1 'NattyUI Basic Feature Demo', <<~TEXT

  This is a short demo of the basic features of {{:i117 bold:}}NattyUI{{:/:}}.

TEXT

UI.h2 'Feature: ANSI Colors and Attributes', <<~TEXT

  Like you might noticed you can {{:i87:}}color {{:i215:}}text{{:/:}} for terminals supporting
  this feature. You can enforece the non-ANSI version by setting the
  environment variable {{:i117 italic:}}ANSI{{:/:}} to '{{:i117:}}0{{:/:}}'.

  You can not only color your text but also {{:bold italic:}}modify{{:/:}} and {{:underline:}}decorate{{:/:}}.
  The attributes are direct embedded into the text like '{{:/bold red:}}'
  and can be resetted with '{{://:}}' or at the line end.

TEXT

UI.h2 'Feature: Sections' do |sec|
  sec.puts <<~TEXT

    Sections group text lines together and/or define their style.
    There are several section types which all can be stacked.

    Have a look at the different types of sections:

  TEXT
  sec.message 'Generic Message'
  sec.information 'Informational Message'
  sec.warning 'Warning Message'
  sec.error 'Error Message'
  sec.completed 'Completion Message'
  sec.failed 'Failure Message'
  sec.msg '{{:i213:}}Customized Message', symbol: '◉'
  sec.space
  sec.puts 'You can stack all kinds of sections together:'
  sec.space
  sec.framed('Simple Framed Section', type: :simple) do |f1|
    f1.framed('Heavy Framed Section', type: :heavy) do |f2|
      f2.framed('Semi Framed Section', type: :semi) do |f3|
        f3.framed('Double Framed Section', type: :double) do |f4|
          f4.message(
            '{{:fff400:}}Frames are nice',
            "Just to show you that all sections\ncan be stacked...",
            symbol: '💛'
          )
        end
      end
    end
  end
  sec.quote <<~TEXT
    This is a quotation.
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed
    do eiusmod tempor incididunt ut labore et dolore magna aliqua.
    Ut enim ad minim veniam, quis nostrud exercitation ullamco
    laboris nisi ut aliquip ex ea commodo consequat.
  TEXT
  sec.space
end

UI.space
