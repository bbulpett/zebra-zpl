require "zebra/epl/printable"

module Zebra
  module Epl
    class Box
      include Printable

      class InvalidLineThickness < StandardError; end

      attr_reader :line_thickness, :end_position, :end_x, :end_y

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def end_position=(coords)
        @end_position, @end_x, @end_y = coords, coords[0], coords[1]
      end

      def to_epl
        check_attributes
        ["X#{x}", y, line_thickness, end_x, end_y].join(",")
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
        raise MissingAttributeError.new("the line thickness is not given") unless line_thickness
        raise MissingAttributeError.new("the horizontal end position (X) is not given") unless end_x
        raise MissingAttributeError.new("the vertical end position (Y) is not given") unless end_y
      end
    end
  end
end
