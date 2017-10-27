require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Raw
      include Printable

      attr_reader :width

      def width=(width)
        unless margin.nil? || margin < 1
          @width = (width - (margin * 2))
        else
          @width = width || 0
        end
      end

      def to_zpl
        # check_attributes
        "^FW#{rotation}^FO#{x},#{y}#{data}^FS"
      end

    end
  end
end
