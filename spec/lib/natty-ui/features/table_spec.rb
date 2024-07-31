# frozen_string_literal: true

RSpec.describe NattyUI::Features::Table do
  it 'is empty by default' do
    table = NattyUI::Features::Table.new
    expect(table.row_count).to be_zero
    expect(table.col_count).to be_zero
    expect(table.to_a).to eq []
  end

  context '.create' do
    it 'can be created from an enumerator' do
      table = NattyUI::Features::Table.create(1..10)
      expect(table.row_count).to be 10
      expect(table.col_count).to be 1
    end

    it 'can be created from a plane' do
      table = NattyUI::Features::Table.create(1..10, 1..2, 1..4, 1..5)
      expect(table.row_count).to be 4
      expect(table.col_count).to be 10
    end
  end

  context '#to_a' do
    it 'reduces empty cells' do
      sample = NattyUI::Features::Table.create(Array.new(10) { Array.new(20) })
      expect(sample.to_a).to eq []
    end

    it 'reduces cells without text' do
      sample = NattyUI::Features::Table.new
      sample.add_row(Array.new(5, ''), align: :center)
      sample.add_row(
        Array.new(5, sample.cell('', align: :right, style: 'bold'))
      )
      expect(sample.to_a).to eq []
    end

    it 'keeps non-empty cells' do
      sample = NattyUI::Features::Table.new
      sample[2, 3] = 'Hello World!'
      sample = sample.to_a
      expect(sample.size).to be 3
      expect(sample.count { _1.is_a?(Array) }).to be 1
      expect(
        sample[-1].count { _1.is_a?(NattyUI::Features::Table::Cell) }
      ).to be 1
    end
  end
end
