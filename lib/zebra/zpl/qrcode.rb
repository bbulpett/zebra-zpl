require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Qrcode
      include Printable

      class InvalidScaleFactorError < StandardError; end
      class InvalidCorrectionLevelError < StandardError; end

      attr_reader :scale_factor, :correction_level, :width

      def width=(width)
        @width = width || 0
      end

      def scale_factor=(value)
        raise InvalidScaleFactorError unless (1..99).include?(value.to_i)
        @scale_factor = value
      end

      def correction_level=(value)
        raise InvalidCorrectionLevelError unless %w[L M Q H].include?(value.to_s)
        @correction_level = value
      end

      def to_zpl
        check_attributes
        "^FW#{rotation}^FO#{x},#{y}^BY,,10^BQN,2,#{scale_factor},,3^FD#{correction_level}A,#{data}^FS"
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the scale factor to be used is not given") unless @scale_factor
        raise MissingAttributeError.new("the error correction level to be used is not given") unless @correction_level
      end
    end
  end
end
