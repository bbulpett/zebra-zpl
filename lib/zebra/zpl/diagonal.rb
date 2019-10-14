require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Diagonal
      include Printable

      class InvalidLineThickness < StandardError; end
      class InvalidColorError < StandardError; end
      class InvalidOrientationError < StandardError; end

      attr_reader :line_thickness, :box_width, :box_height, :color, :orientation

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def box_width=(width)
        @box_width = width
      end

      def box_height=(height)
        @box_height = height
      end

      def color=(value)
        raise InvalidColorError unless %w[B W].include?(value&.upcase)
        @color = value
      end

      def orientation=(value)
        raise InvalidOrientationError unless %w[R L].include?(value&.upcase)
        @orientation = value
      end

      def to_zpl
        check_attributes
        "^FO#{x},#{y}^GD#{box_width},#{box_height},#{line_thickness},#{color},#{orientation}^FS"
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
        raise MissingAttributeError.new("the box_width is not given") unless box_width
        raise MissingAttributeError.new("the box_height is not given") unless box_height
      end
    end
  end
end
