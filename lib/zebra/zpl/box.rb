require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Box
      include Printable

      class InvalidLineThickness < StandardError; end

      attr_reader :line_thickness, :box_width, :box_height, :width

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def box_width=(width)
        @box_width = width
      end

      ### The method below refers to the "label width"
      def width=(width)
        @width = width || 0
      end

      def box_height=(height)
        @box_height = height
      end

      def to_zpl
        check_attributes
        # "^FO#{x},#{y}^GB#{box_width},#{box_height},#{line_thickness}^FS"
        "^FO#{x},#{y}^GB#{box_width},#{box_height},#{line_thickness}^FS"
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
        raise MissingAttributeError.new("the line thickness is not given") unless line_thickness
        raise MissingAttributeError.new("the box_width is not given") unless box_width
        raise MissingAttributeError.new("the box_height is not given") unless box_height
      end
    end
  end
end
