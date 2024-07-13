# frozen_string_literal: true

require_relative 'ansi'

module NattyUI
  module Text
    class << self
      def plain(str) = Ansi.blemish(plain_but_ansi(str))

      def plain_but_ansi(str)
        (str = str.to_s).empty? and return str
        str.gsub(/(\[\[((?~\]\]))\]\])/) do
          match = Regexp.last_match[2]
          next match.size == 1 ? nil : "[[#{match[1..]}]]" if match[0] == '/'
          Ansi.try_convert(match) ? nil : "[[#{match}]]"
        end
      end

      def embellish(str)
        (str = str.to_s).empty? and return str
        reset = false
        str =
          str.gsub(/(\[\[((?~\]\]))\]\])/) do
            match = Regexp.last_match[2]
            if match[0] == '/'
              next "[[#{match[1..]}]]" if match.size > 1
              reset = false
              next Ansi::RESET
            end
            ansi = Ansi.try_convert(match)
            ansi ? reset = ansi : "[[#{match}]]"
          end
        reset ? "#{str}#{Ansi::RESET}" : str
      end

      def width(str)
        return 0 if (str = plain(str)).empty?
        str = str.encode(UTF_8) if str.encoding != UTF_8
        width = 0
        in_zero_width = false
        str.scan(WIDTH_SCANNER) do |np_start, np_end, _csi, _osc, gc|
          if in_zero_width
            in_zero_width = false if np_end
            next
          end
          next in_zero_width = true if np_start
          width += char_width(gc) if gc
        end
        width
      end

      def char_width(char)
        ord = char.ord
        return SPECIAL_CHARS[ord] || 2 if ord <= 0x1f
        return 1 if ord <= 0x7e
        size = EastAsianWidth[ord]
        return @ambiguous_char_width if size == -1
        if size == 1 && char.size >= 2
          sco = char[1].ord
          # Halfwidth Dakuten Handakuten
          return sco == 0xff9e || sco == 0xff9f ? 2 : 1
        end
        size
      end

      def simple_each_line(strs, &block)
        strs.each { _1.to_s.each_line(chomp: true, &block) }
        nil
      end

      def each_line(strs, max_width)
        return if (max_width = max_width.to_i) <= 0
        strs.each do |str|
          str
            .to_s
            .each_line(chomp: true) do |line|
              next yield(line) if line.empty?
              current = String.new(encoding: line.encoding)
              seq = current.dup
              width = 0
              in_zero_width = false
              line = line.encode(UTF_8) if line.encoding != UTF_8
              line.scan(WIDTH_SCANNER) do |np_start, np_end, csi, osc, gc|
                next in_zero_width = (current << "\1") if np_start
                next in_zero_width = !(current << "\2") if np_end
                next (current << osc) && (seq << osc) if osc
                if csi
                  current << csi
                  next if in_zero_width
                  next seq.clear if csi == "\e[m" || csi == "\e[0m"
                  next seq << csi
                end
                next current << gc if in_zero_width
                cw = char_width(gc)
                if (width += cw) > max_width
                  yield(current)
                  width = cw
                  current = seq.dup
                end
                current << gc
              end
              yield(current)
            end
        end
        nil
      end

      def each_line_with_size(strs, max_width)
        return if (max_width = max_width.to_i) <= 0
        strs.each do |str|
          str
            .to_s
            .each_line(chomp: true) do |line|
              next yield(line, 0) if line.empty?
              current = String.new(encoding: line.encoding)
              seq = current.dup
              width = 0
              in_zero_width = false
              line = line.encode(UTF_8) if line.encoding != UTF_8
              line.scan(WIDTH_SCANNER) do |np_start, np_end, csi, osc, gc|
                next in_zero_width = (current << "\1") if np_start
                next in_zero_width = !(current << "\2") if np_end
                next (current << osc) && (seq << osc) if osc
                if csi
                  current << csi
                  next if in_zero_width
                  next seq.clear if csi == "\e[m" || csi == "\e[0m"
                  next seq << csi
                end
                next current << gc if in_zero_width
                cw = char_width(gc)
                if (width += cw) > max_width
                  yield(current, width - cw)
                  width = cw
                  current = seq.dup
                end
                current << gc
              end
              yield(current, width)
            end
        end
        nil
      end

      def as_lines(strs, max_width)
        ret = []
        each_line(strs, max_width) { ret << _1 }
        ret
      end

      def prepare_print(args, kwargs, screen_columns, &cvt)
        prefix = kwargs[:prefix] and prefix = prefix.empty? ? '' : cvt[prefix]
        suffix = kwargs[:suffix] and suffix = suffix.empty? ? '' : cvt[suffix]
        return ["#{prefix}#{suffix}"] if args.empty?
        ret = []
        each_line(
          args.map!(&cvt),
          kwargs.fetch(:max_width) do
            screen_columns.call -
              kwargs.fetch(:prefix_width) { width(prefix) } -
              kwargs.fetch(:suffix_width) { width(suffix) }
          end
        ) { ret << "#{prefix}#{_1}#{suffix}" }
        ret
      end
    end

    UTF_8 = Encoding::UTF_8

    WIDTH_SCANNER = /\G(?:(\1)|(\2)|(#{Ansi::CSI})|(#{Ansi::OSC})|(\X))/

    SPECIAL_CHARS = {
      0x00 => 0,
      0x01 => 1,
      0x02 => 1,
      0x03 => 1,
      0x04 => 1,
      0x05 => 0,
      0x06 => 1,
      0x07 => 0,
      0x08 => 0,
      0x09 => 8,
      0x0a => 0,
      0x0b => 0,
      0x0c => 0,
      0x0d => 0,
      0x0e => 0,
      0x0f => 0,
      0x10 => 1,
      0x11 => 1,
      0x12 => 1,
      0x13 => 1,
      0x14 => 1,
      0x15 => 1,
      0x16 => 1,
      0x17 => 1,
      0x18 => 1,
      0x19 => 1,
      0x1a => 1,
      0x1b => 1,
      0x1c => 1,
      0x1d => 1,
      0x1e => 1,
      0x1f => 1
    }.compare_by_identity.freeze

    autoload(:EastAsianWidth, File.join(__dir__, 'text', 'east_asian_width'))

    @ambiguous_char_width = 1
  end

  private_constant :Text
end
