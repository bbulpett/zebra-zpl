module Zebra
  module Zpl
    module FontSize
      class InvalidFontSizeError < StandardError; end

      SIZE_1 = 17 # 6pt
      SIZE_2 = 22 # 8pt
      SIZE_3 = 28 # 10pt
      SIZE_4 = 33 # 12pt
      SIZE_5 = 44 # 16pt
      SIZE_6 = 67 # 24pt
      SIZE_7 = 100 # 32pt
      SIZE_8 = 111 # 40pt
      SIZE_9 = 133 # 48pt

      def self.valid_font_size?(font_size)
        [17, 22, 28, 33, 44, 67, 100, 111, 133].include?(font_size.to_i) || ('A'..'Z').include?(font_size)
      end

      def self.validate_font_size(font_size)
        raise InvalidFontSizeError unless valid_font_size?(font_size)
      end
    end
  end
end
