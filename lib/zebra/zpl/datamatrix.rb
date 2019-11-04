require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Datamatrix
      include Printable

      class InvalidOrientationError < StandardError; end
      class InvalidQualityFactorError < StandardError; end
      class InvalidSizeError < StandardError; end
      class InvalidFormatError < StandardError; end
      class InvalidRatioError < StandardError; end

      attr_reader :symbol_height, :columns, :rows, :format, :aspect_ratio, :width
      attr_accessor :escape_sequence

      def width=(width)
        @width = width || 0
      end

      def orientation=(value)
        raise InvalidOrientationError unless %w[N R I B].include?(value)
        @orientation = value
      end

      def orientation
        @orientation || 'N'
      end

      def symbol_height=(height)
        @symbol_height = height
      end

      def quality=(level)
        raise InvalidQualityFactorError unless [0, 50, 80, 100, 140, 200].include?(level.to_i)
        @quality = level
      end

      def quality
        @quality || 200
      end

      def columns=(n)
        raise InvalidSizeError unless (9..49).include?(n.to_i)
        @columns = n
      end

      def rows=(n)
        raise InvalidSizeError unless (9..49).include?(n.to_i)
        @rows = n
      end

      def format=(value)
        raise InvalidFormatError unless (0..6).include?(value.to_i)
        @format = value
      end

      def aspect_ratio=(value)
        raise InvalidRatioError unless [1, 2].include?(value.to_i)
        @aspect_ratio = value
      end

      def to_zpl
        check_attributes
        "^FW#{rotation}^FO#{x},#{y}^BY,,10^BX#{orientation},#{symbol_height},#{quality},#{columns},#{rows},#{format},#{escape_sequence},#{aspect_ratio}^FD#{data}^FS"
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the symbol height to be used is not given") unless @symbol_height
      end
    end
  end
end
