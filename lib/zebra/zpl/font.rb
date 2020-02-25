module Zebra
  module Zpl
    module FontSize
      class InvalidFontSizeError < StandardError; end

      SIZE_0 = 12 # tiny
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
        (0..32000).include?(font_size.to_i)
      end

      def self.validate_font_size(font_size)
        raise InvalidFontSizeError unless valid_font_size?(font_size)
      end
    end

    module FontType
      class InvalidFontTypeError < StandardError; end

      TYPE_0  = "0" # 6pt
      TYPE_CD = "CD" # 6pt
      TYPE_A  = "A" # 6pt
      TYPE_B  = "B" # 6pt
      TYPE_E  = "E" # 6pt
      TYPE_F  = "F" # 6pt
      TYPE_G  = "G" # 6pt
      TYPE_H  = "H" # 6pt

      def self.valid_font_type?(font_type)
        ["0", "CD", "A", "B", "E", "F", "G", "H"].include?(font_type)
      end

      def self.validate_font_type(font_type)
        raise InvalidFontTypeError unless valid_font_type?(font_type)
      end
    end
  end
end
