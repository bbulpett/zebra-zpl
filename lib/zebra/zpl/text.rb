require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Text
      include Printable

      attr_reader   :font_size, :width

      def font_size=(f)
        FontSize.validate_font_size f
        @font_size = f
      end

      def print_mode=(mode)
        PrintMode.validate_mode mode
        @print_mode = mode
      end

      def print_mode
        @print_mode || PrintMode::NORMAL
      end

      def h_multiplier
        @h_multiplier || HorizontalMultiplier::VALUE_1
      end

      def v_multiplier
        @v_multiplier || VerticalMultiplier::VALUE_1
      end

      def print_mode
        @print_mode || PrintMode::NORMAL
      end

      def h_multiplier=(multiplier)
        HorizontalMultiplier.validate_multiplier multiplier
        @h_multiplier = multiplier
      end

      def v_multiplier=(multiplier)
        VerticalMultiplier.validate_multiplier multiplier
        @v_multiplier = multiplier
      end

      def to_zpl
        # debugger
        check_attributes
        # ["A#{x}", y, rotation, font_size, h_multiplier, v_multiplier, print_mode, "\"#{data}\""].join(",")
        # "A#{x}, y, rotation, font_size, h_multiplier, v_multiplier, print_mode, #{data}"
        "^FB800,100,0,C,0^FD#{data}^FS"
      end

      private

      def check_attributes
        super
        raise MissingAttributeError.new("the font_size to be used is not given") unless @font_size
      end
    end
  end
end
