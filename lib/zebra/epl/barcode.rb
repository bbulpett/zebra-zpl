require "zebra/epl/printable"

module Zebra
  module Epl
    class Barcode
      include Printable

      class InvalidNarrowBarWidthError < StandardError; end
      class InvalidWideBarWidthError   < StandardError; end

      attr_accessor :height
      attr_reader :type, :narrow_bar_width, :wide_bar_width
      attr_writer :print_human_readable_code

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

      def to_epl
        check_attributes
        human_readable = print_human_readable_code ? "B" : "N"
        ["B#{x}", y, rotation, type, narrow_bar_width, wide_bar_width, height, human_readable, "\"#{data}\""].join(",")
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
