module Zebra
  module Zpl
    module FontSize
      class InvalidFontSizeError < StandardError; end

      SIZE_1 = 1
      SIZE_2 = 2
      SIZE_3 = 3
      SIZE_4 = 4
      SIZE_5 = 5

      def self.valid_font_size?(font_size)
        (1..5).include?(font_size.to_i) || ('A'..'Z').include?(font_size)
      end

      def self.validate_font_size(font_size)
        raise InvalidFontSizeError unless valid_font_size?(font_size)
      end
    end
  end
end
