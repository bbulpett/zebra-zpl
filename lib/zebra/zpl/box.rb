require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Box
      include Printable

      class InvalidLineThickness < StandardError; end

      attr_reader :line_thickness, :box_width, :box_height, :width, :reverse_type

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def box_width=(value)
        @box_width = value
      end

      ### The method below refers to the "label width"
      def width=(value)
        @width = value || 0
      end

      def box_height=(value)
        @box_height = value
      end

      def reverse_type=(value)
        @reverse_type = value
      end

      def to_zpl
        check_attributes
        "^FO#{x},#{y}#{'^FR' if reverse_type}^GB#{box_width},#{box_height},#{line_thickness}^FS"
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
