require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Circle
      include Printable

      class InvalidLineThickness < StandardError; end
      class InvalidColorError < StandardError; end

      attr_reader :line_thickness, :diameter, :color

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def diameter=(value)
        @diameter= value
      end

      def color=(value)
        raise InvalidColorError unless value&.upcase.in?(["B","W"])
        @color = value
      end

      def to_zpl
        check_attributes
        "^FO#{x},#{y}^GC#{diameter},#{line_thickness},#{color}^FS"
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
        raise MissingAttributeError.new("the circle diameter is not given") unless diameter
      end
    end
  end
end
