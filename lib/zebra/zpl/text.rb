require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Text
      include Printable

      class InvalidMaxLinesError < StandardError; end

      attr_reader :font_size, :font_type, :width, :line_spacing, :hanging_indent, :bold
      attr_writer :reverse_print

      def font_size=(f)
        FontSize.validate_font_size f
        @font_size = f
      end

      def bold=(value)
        @bold = value
      end

      def width=(width)
        if (margin.nil? || margin < 1)
          @width = width || 0
        else
          @width = (width - (margin*2))
        end
      end

      def max_lines=(value)
        raise InvalidMaxLinesError unless value.to_i >= 1
        @max_lines = value
      end

      def max_lines
        @max_lines || 4
      end

      def line_spacing=(value)
        @line_spacing = value || 0
      end

      def hanging_indent=(value)
        @hanging_indent = value || 0
      end

      def font_type=(type)
        FontType.validate_font_type type
        @font_type = type
      end

      def font_type
        @font_type || FontType::TYPE_0
      end

      def reverse_print
        @reverse_print || false
      end

      def to_zpl
        check_attributes
        if !bold.nil?
          "^FW#{rotation}^A#{font_type},#{font_size}^CI28^FO#{x+1},#{y}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}#{appear_in_reverse}^FD#{data}^FS" +
          "^FW#{rotation}^A#{font_type},#{font_size}^CI28^FO#{x},#{y+1}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}#{appear_in_reverse}^FD#{data}^FS"
        else
          "^FW#{rotation}^A#{font_type},#{font_size}^CI28^FO#{x},#{y}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}#{appear_in_reverse}^FD#{data}^FS"
        end
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the font_size to be used is not given") unless @font_size
      end

      def appear_in_reverse
        reverse_print ? '^FR' : ''
      end
    end
  end
end
