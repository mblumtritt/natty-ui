# frozen_string_literal: true

module NattyUI
  KEY_MAP =
    Module # generator
      .new do
        def self.add_modifiers(**keys)
          @mods.each_pair do |mod, pref|
            @map.merge!(
              keys.to_h do |name, code|
                ["\e[1;#{mod}#{code}", "#{pref}+#{name}"]
              end
            )
          end
        end

        def self.add_keys(**keys)
          @map.merge!(keys.to_h { |name, code| ["\e[#{code}", name] })
          add_modifiers(**keys)
        end

        def self.add_fkeys(**keys)
          @map.merge!(keys.to_h { |name, code| ["\e[#{code}~", name] })
          @mods.each_pair do |mod, prefix|
            @map.merge!(
              keys.to_h do |name, code|
                ["\e[#{code};#{mod}~", "#{prefix}+#{name}"]
              end
            )
          end
        end

        def self.add_alt_keys(**keys)
          keys.each_pair do |name, code|
            @map[code] = name
            @map["\e#{code}"] = "Alt+#{name}" # kitty
          end
        end

        def self.to_hash
          # control codes
          num = 0
          @map = ('A'..'Z').to_h { [(num += 1).chr, "Ctrl+#{_1}"] }

          add_modifiers('F1' => 'P', 'F2' => 'Q', 'F3' => 'R', 'F4' => 'S')

          add_keys(
            'Up' => 'A',
            'Down' => 'B',
            'Right' => 'C',
            'Left' => 'D',
            'End' => 'F',
            'Home' => 'H'
          )

          add_fkeys(
            'DEL' => '3',
            'PgUp' => '5',
            'PgDown' => '6',
            # -
            'F1' => 'F1',
            'F2' => 'F2',
            'F3' => 'F3',
            'F4' => 'F4',
            # -
            'F5' => '15',
            'F6' => '17',
            'F7' => '18',
            'F8' => '19',
            'F9' => '20',
            'F10' => '21',
            'F11' => '23',
            'F12' => '24',
            'F13' => '25',
            'F14' => '26',
            'F15' => '28',
            'F16' => '29',
            'F17' => '31',
            'F18' => '32',
            'F19' => '33',
            'F20' => '34'
          )

          add_fkeys('F3' => '13') # kitty

          add_alt_keys(
            'ESC' => "\e",
            'ENTER' => "\r",
            'TAB' => "\t",
            'BACK' => "\u007F",
            'Ctrl+BACK' => "\b",
            'Shift+TAB' => "\e[Z"
          )

          # overrides and additionals
          @map.merge!(
            "\4" => 'DEL',
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
