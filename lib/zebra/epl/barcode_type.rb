module Zebra
  module Epl
    module BarcodeType
      class InvalidBarcodeTypeError < StandardError; end

      CODE_39             = "3"
      CODE_39_CHECK_DIGIT = "3C"
      CODE_93             = "9"
      CODE_128_AUTO       = "1"
      CODE_128_A          = "1A"
      CODE_128_B          = "1B"
      CODE_128_C          = "1C"
      CODABAR             = "K"

      def self.valid_barcode_type?(type)
        %w(3 3C 9 1 1A 1B 1C K).include? type
      end

      def self.validate_barcode_type(type)
        raise InvalidBarcodeTypeError unless valid_barcode_type?(type)
      end
    end
  end
end
