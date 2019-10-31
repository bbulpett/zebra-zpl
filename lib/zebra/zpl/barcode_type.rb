module Zebra
  module Zpl
    module BarcodeType
      class InvalidBarcodeTypeError < StandardError; end

      CODE_39             = "3"
      CODE_93             = "A"
      CODE_128_AUTO       = "C"
      CODABAR             = "K"
      CODE_AZTEC          = "0"
      CODE_AZTEC_PARAMS   = "O"
      CODE_UPS_MAXICODE   = "D"
      CODE_QR             = "Q"
      CODE_UPCA           = "U"
      CODE_UPCE           = "9"
      CODE_EAN13          = "E"

      # Legacy (EPL) bar code suffixes
      # CODE_39             = "3"
      # CODE_39_CHECK_DIGIT = "3C"
      # CODE_93             = "9"
      # CODE_128_AUTO       = "1"
      # CODE_128_A          = "1A"
      # CODE_128_B          = "1B"
      # CODE_128_C          = "1C"
      # CODABAR             = "K"

      def self.valid_barcode_type?(type)
        %w(3 A C K 0 O D Q U 9 E).include? type
      end

      def self.validate_barcode_type(type)
        raise InvalidBarcodeTypeError unless valid_barcode_type?(type)
      end
    end
  end
end
