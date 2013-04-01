module Zebra
  module Epl
    module Font
      class InvalidFontError < StandardError; end

      SIZE_1 = 1
      SIZE_2 = 2
      SIZE_3 = 3
      SIZE_4 = 4
      SIZE_5 = 5

      def self.valid_font?(font)
        (1..5).include?(font.to_i) || ('A'..'Z').include?(font)
      end

      def self.validate_font(font)
        raise InvalidFontError unless valid_font?(font)
      end
    end
  end
end
