# frozen_string_literal: true

module NattyUI
  KEY_MAP =
    Module # generator
      .new do
        def self.add_mods(name, code)
          @mods.each_pair do |mod, prefix|
            @map["\e[1;#{mod}#{code}"] = "#{prefix}+#{name}"
          end
        end

        def self.add_akey(name, code)
          @map["\e[#{code}"] = name
          add_mods(name, code)
        end

        def self.add_fkey(name, code)
          @map["\e[#{code}~"] = name
          @mods.each_pair do |mod, prefix|
            @map["\e[#{code};#{mod}~"] = "#{prefix}+#{name}"
          end
        end

        def self.to_hash
          # control codes
          num = 0
          @map = ('A'..'Z').to_h { [(num += 1).chr, "Ctrl+#{_1}"] }

          add_akey('Up', 'A')
          add_akey('Down', 'B')
          add_akey('Right', 'C')
          add_akey('Left', 'D')
          add_akey('End', 'F')
          add_akey('Home', 'H')

          add_mods('F1', 'P')
          add_mods('F2', 'Q')
          add_mods('F3', 'R')
          add_mods('F4', 'S')

          add_fkey('DEL', '3')
          add_fkey('PgUp', '5')
          add_fkey('PgDown', '6')
          add_fkey('F1', 'F1')
          add_fkey('F2', 'F2')
          add_fkey('F3', 'F3')
          add_fkey('F4', 'F4')
          add_fkey('F5', '15')
          add_fkey('F6', '17')
          add_fkey('F7', '18')
          add_fkey('F8', '19')
          add_fkey('F9', '20')
          add_fkey('F10', '21')
          add_fkey('F11', '23')
          add_fkey('F12', '24')
          add_fkey('F13', '25')
          add_fkey('F14', '26')
          add_fkey('F15', '28')
          add_fkey('F16', '29')
          add_fkey('F17', '31')
          add_fkey('F18', '32')
          add_fkey('F19', '33')
          add_fkey('F20', '34')

          # overrides and additionals
          @map.merge!(
            "\e" => 'ESC',
            "\4" => 'DEL', # = Ctrl+D
            "\u007F" => 'BACK',
            "\b" => 'Ctrl+BACK',
            "\r" => 'ENTER', # = Ctrl+M
            "\t" => 'TAB',
            "\e[Z" => 'Shift+TAB',
            "\e[5" => 'PgUp',
            "\e[6" => 'PgDown',
            # SS3 control (VT 100 etc)
            "\eOA" => 'Up',
            "\eOB" => 'Down',
            "\eOC" => 'Right',
            "\eOD" => 'Left',
            "\eOP" => 'F1',
            "\eOQ" => 'F2',
            "\eOR" => 'F3',
            "\eOS" => 'F4',
            "\eO2P" => 'Shift+F1',
            "\eO2Q" => 'Shift+F2',
            "\eO2R" => 'Shift+F3',
            "\eO2S" => 'Shift+F4',
            "\eOt" => 'F5',
            "\eOu" => 'F6',
            "\eOv" => 'F7',
            "\eOw" => 'F8',
            "\eOl" => 'F9',
            "\eOx" => 'F10'
          )
        end

        @mods = {
          2 => 'Shift',
          3 => 'Alt',
          4 => 'Alt-Shift',
          5 => 'Ctrl',
          6 => 'Ctrl-Shift',
          7 => 'Ctrl-Alt',
          8 => 'Ctrl-Alt-Shift',
          9 => 'Meta',
          10 => 'Meta-Shift',
          11 => 'Meta-Alt',
          12 => 'Meta-Alt-Shift',
          13 => 'Ctrl-Meta',
          14 => 'Ctrl-Meta-Shift',
          15 => 'Ctrl-Meta-Alt',
          16 => 'Ctrl-Meta-Alt-Shift'
        }.compare_by_identity
      end
      .to_hash
      .freeze
end
