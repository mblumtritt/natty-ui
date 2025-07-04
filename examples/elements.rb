# frozen_string_literal: true

require_relative '../lib/natty-ui'

ui.message '[b]​ᓚᕠᗢ NattyUI[/b] [i green]Simple Elements[/]' do
  ui.space
  ui.h1('This is a [b]H1[/b] heading element')

  ui.space
  ui.h2('This is a [b]H2[/b] heading element')

  ui.space
  ui.quote "This is a\nmulti-line quotation"

  ui.space
  ui.h3('This is a [b]H3[/b] heading element')
  ui.mark(
    'This is a multi-line message',
    'with a leading checkmark.',
    mark: :checkmark
  )

  ui.space
  ui.h4('This is a [b]H4[/b] heading element')

  ui.space
  ui.h5('This is a [b]H5[/b] heading element')

  ui.space
  ui.h6('This is a [b]H6[/b] heading element')
end
