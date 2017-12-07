require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Barcode
      include Printable

      class InvalidNarrowBarWidthError < StandardError; end
      class InvalidWideBarWidthError   < StandardError; end

      attr_accessor :height
      attr_reader :type, :narrow_bar_width, :wide_bar_width, :width
      attr_writer :print_human_readable_code

      def width=(width)
        @width = width || 0
      end

      def type=(type)
        BarcodeType.validate_barcode_type(type)
        @type = type
      end

      def narrow_bar_width=(width)
        raise InvalidNarrowBarWidthError unless (1..10).include?(width.to_i)
        @narrow_bar_width = width
      end

      def wide_bar_width=(width)
        raise InvalidWideBarWidthError unless (2..30).include?(width.to_i)
        @wide_bar_width = width
      end

      def print_human_readable_code
        @print_human_readable_code || false
      end

      def to_zpl
        check_attributes
        human_readable = print_human_readable_code ? "Y" : "N"
        "^FW#{rotation}^FO#{x},#{y}^BY#{narrow_bar_width}^B#{type}#{rotation},N,#{height},#{human_readable}^FD#{data}^FS"
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the barcode type to be used is not given") unless @type
        raise MissingAttributeError.new("the height to be used is not given") unless @height
        raise MissingAttributeError.new("the narrow bar width to be used is not given") unless @narrow_bar_width
        raise MissingAttributeError.new("the wide bar width to be used is not given") unless @wide_bar_width
      end
    end
  end
end
