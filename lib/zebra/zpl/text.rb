require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Text
      include Printable

      class InvalidMaxLinesError < StandardError; end

      attr_reader :font_size, :font_type, :width, :line_spacing, :hanging_indent, :bold

      def font_size=(f)
        FontSize.validate_font_size f
        @font_size = f
      end

      def bold=(value)
        @bold = value
      end

      def width=(width)
        unless (margin.nil? || margin < 1)
          @width = (width - (margin*2))
        else
          @width = width || 0
        end
      end

      def max_lines=(value)
        raise InvalidMaxLinesError unless value.to_i >= 1
        @max_lines = value
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

      def print_mode=(mode)
        PrintMode.validate_mode mode
        @print_mode = mode
      end

      def print_mode
        @print_mode || PrintMode::NORMAL
      end

      # def h_multiplier
      #   @h_multiplier || HorizontalMultiplier::VALUE_1
      # end
      #
      # def v_multiplier
      #   @v_multiplier || VerticalMultiplier::VALUE_1
      # end

      def print_mode
        @print_mode || PrintMode::NORMAL
      end

      def max_lines
        @max_lines || 4
      end

      # def h_multiplier=(multiplier)
      #   HorizontalMultiplier.validate_multiplier multiplier
      #   @h_multiplier = multiplier
      # end
      #
      # def v_multiplier=(multiplier)
      #   VerticalMultiplier.validate_multiplier multiplier
      #   @v_multiplier = multiplier
      # end

      def to_zpl
        check_attributes
        if !bold.nil?
          "^FW#{rotation}^CF#{font_type},#{font_size}^CI28^FO#{x+2},#{y}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}^FD#{data}^FS" +
          "^FW#{rotation}^CF#{font_type},#{font_size}^CI28^FO#{x},#{y+2}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}^FD#{data}^FS"
        else
          "^FW#{rotation}^CF#{font_type},#{font_size}^CI28^FO#{x},#{y}^FB#{width},#{max_lines},#{line_spacing},#{justification},#{hanging_indent}^FD#{data}^FS"
        end
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the font_size to be used is not given") unless @font_size
      end
    end
  end
end
