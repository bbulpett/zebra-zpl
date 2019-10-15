require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Graphic
      include Printable

      class InvalidLineThickness < StandardError; end
      class InvalidColorError < StandardError; end
      class InvalidOrientationError < StandardError; end
      class InvalidGraphicType < StandardError; end

      alias_attribute :diameter, :graphic_width

      attr_reader :line_thickness, :graphic_width, :graphic_height, :color, :orientation, :rounding_degree, :graphic_type

      ELIPSE   = "E"
      BOX      = "B"
      DIAGONAL = "D"
      CIRCLE   = "C"
      SYMBOL   = "S"

      def graphic_type=(type)
        raise InvalidGraphicType unless %w(E B D C S).include? type
        @graphic_type = type
      end

      def self.valid_graphic_type?(type)
        
      end

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def graphic_width=(width)
        @graphic_width = width
      end

      def graphic_height=(height)
        @graphic_height = height
      end

      def color=(value)
        raise InvalidColorError unless %w[R L].include?(value&.upcase)
        @color = value
      end

      def orientation=(value)
        raise InvalidOrientationError unless %w[R L].include?(value&.upcase)
        @orientation = value
      end

      def to_zpl
        check_attributes
        zpl = case graphic_type 
        when "B"
            "B#{graphic_width},#{graphic_height},#{line_thickness},#{color},#{orientation}"
        when "E"
            "E#{graphic_width},#{graphic_height},#{line_thickness},#{color}"
        when "C"
            "C#{diameter},#{line_thickness},#{color}"
        when "D"
            "D#{graphic_width},#{graphic_height},#{line_thickness},#{color},#{orientation}"
        when "S"
            "S#{orientation},#{graphic_height},#{graphic_width}"
        end
        "^FO#{x},#{y}^G#{zpl}^FS"
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
      end
    end
  end
end
