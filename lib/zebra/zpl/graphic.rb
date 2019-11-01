require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Graphic
      include Printable

      class InvalidGraphicType < StandardError; end
      class InvalidLineThickness < StandardError; end
      class InvalidColorError < StandardError; end
      class InvalidOrientationError < StandardError; end
      class InvalidRoundingDegree < StandardError; end
      class InvalidSymbolType < StandardError; end

      attr_reader :graphic_type, :graphic_width, :graphic_height, :line_thickness, :color, :orientation, :rounding_degree, :symbol_type

      BOX      = "B"
      CIRCLE   = "C"
      DIAGONAL = "D"
      ELLIPSE  = "E"
      SYMBOL   = "S"

      def graphic_type=(type)
        raise InvalidGraphicType unless %w(E B D C S).include? type
        @graphic_type = type
      end

      def graphic_width=(width)
        @graphic_width = width
      end

      def graphic_height=(height)
        @graphic_height = height
      end

      def line_thickness=(thickness)
        raise InvalidLineThickness unless thickness.nil? || thickness.to_i.to_s == thickness.to_s
        @line_thickness = thickness
      end

      def color=(value)
        raise InvalidColorError unless %w[B W].include?(value&.upcase)
        @color = value
      end

      def orientation=(value)
        raise InvalidOrientationError unless %w[R L].include?(value&.upcase)
        @orientation = value
      end

      def rounding_degree=(value)
        raise InvalidRoundingDegree unless (0..8).include?(value.to_i)
        @rounding_degree = value
      end

      def symbol_type=(value)
        raise InvalidSymbolType unless %w[A B C D E].include?(value.upcase)
        @symbol_type = value
      end

      def to_zpl
        check_attributes
        graphic = case graphic_type
        when "B"
          "B#{graphic_width},#{graphic_height},#{line_thickness},#{color},#{rounding_degree}"
        when "C"
          "C#{graphic_width},#{line_thickness},#{color}"
        when "D"
          "D#{graphic_width},#{graphic_height},#{line_thickness},#{color},#{orientation}"
        when "E"
          "E#{graphic_width},#{graphic_height},#{line_thickness},#{color}"
        when "S"
          sym = !symbol_type.nil? ? "^FD#{symbol_type}" : ''
          "S,#{graphic_height},#{graphic_width}#{sym}"
        end
        "^FW#{rotation}^FO#{x},#{y}^G#{graphic}^FS"
      end

      private

      def has_data?
        false
      end

      def check_attributes
        super
        raise InvalidGraphicType if @graphic_type.nil?
      end
    end
  end
end
