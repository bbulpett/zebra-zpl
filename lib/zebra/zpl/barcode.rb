require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Barcode
      include Printable

      class InvalidRatioError < StandardError; end
      class InvalidNarrowBarWidthError < StandardError; end
      class InvalidWideBarWidthError   < StandardError; end

      attr_accessor :height, :mode
      attr_reader :type, :ratio, :narrow_bar_width, :wide_bar_width
      attr_writer :print_human_readable_code, :print_text_above

      def width=(value)
        @width = value || 0
      end

      def width
        @width || @narrow_bar_width || @wide_bar_width || 0
      end

      def type=(type)
        BarcodeType.validate_barcode_type(type)
        @type = type
      end

      def ratio=(value)
        raise InvalidRatioError unless value.to_f >= 2.0 && value.to_f <= 3.0
        @ratio = value
      end

      def ratio
        if !@wide_bar_width.nil? && !@narrow_bar_width.nil?
          (@wide_bar_width.to_f / @narrow_bar_width.to_f).round(1)
        else
          @ratio
        end
      end

      def narrow_bar_width=(value)
        raise InvalidNarrowBarWidthError unless (1..10).include?(value.to_i)
        @narrow_bar_width = value
      end

      def wide_bar_width=(value)
        raise InvalidWideBarWidthError unless (2..30).include?(value.to_i)
        @wide_bar_width = value
      end

      def print_human_readable_code
        @print_human_readable_code || false
      end

      def print_text_above
        @print_text_above || false
      end

      def to_zpl
        check_attributes

        barcode = case type
        when BarcodeType::CODE_39
          # Code 39 Bar Code: ^B3o,e,h,f,g
          "^B3#{rotation},,,#{interpretation_line},#{interpretation_line_above}"
        when BarcodeType::CODE_93
          # Code 93 Bar Code: ^BAo,h,f,g,e
          "^BA#{rotation},,#{interpretation_line},#{interpretation_line_above}"
        when BarcodeType::CODE_128_AUTO
          # Code 128 Bar Code: ^BCo,h,f,g,e,m
          "^BC#{rotation},,#{interpretation_line},#{interpretation_line_above},,#{mode}"
        when BarcodeType::CODABAR
          # ANSI Codabar Bar Code: ^BKo,e,h,f,g,k,l
          "^BK#{rotation},,,#{interpretation_line},#{interpretation_line_above}"
        when BarcodeType::CODE_AZTEC
          # Aztec Bar Code Parameters: ^B0a,b,c,d,e,f,g
          "^B0#{rotation},6"
        when BarcodeType::CODE_AZTEC_PARAMS
          # Aztec Bar Code Parameters: ^BOa,b,c,d,e,f,g
          "^BO#{rotation},6"
        when BarcodeType::CODE_UPS_MAXICODE
          # UPS MaxiCode Bar Code: ^BDm,n,t
          "^BD"
        when BarcodeType::CODE_QR
          # QR Code Bar Code: ^BQa,b,c,d,e
          "^BQ#{rotation}"
        when BarcodeType::CODE_UPCA
          # UPC-A Bar Code: ^BUo,h,f,g,e
        when BarcodeType::CODE_UPCE
          # UPC-E Bar Code: ^B9o,h,f,g,e
          "^B9#{rotation},,#{interpretation_line},#{interpretation_line_above}"
        when BarcodeType::CODE_EAN8
          # EAN-8 Bar Code: ^B8o,h,f,g
          "^B8#{rotation},,#{interpretation_line},#{interpretation_line_above}"
        when BarcodeType::CODE_EAN13
          # EAN-13 Bar Code: ^BEo,h,f,g
          "^BE#{rotation},,#{interpretation_line},#{interpretation_line_above}"
        else
          raise BarcodeType::InvalidBarcodeTypeError
        end

        "^FW#{rotation}^FO#{x},#{y}^BY#{width},#{ratio},#{height}#{barcode}^FD#{data}^FS"
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the barcode type to be used is not given") unless @type
        raise MissingAttributeError.new("the height to be used is not given") unless @height
        raise MissingAttributeError.new("the width to be used is not given") unless @width || @narrow_bar_width || @wide_bar_width
      end

      def interpretation_line
        print_human_readable_code ? "Y" : "N"
      end

      def interpretation_line_above
        print_text_above ? "Y" : "N"
      end
    end
  end
end
