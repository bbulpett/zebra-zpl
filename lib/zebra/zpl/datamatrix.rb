require "zebra/zpl/printable"

module Zebra
  module Zpl
        class Datamatrix
                include Printable

                attr_reader :orientation, :height_of_symbol, :quality_level, :columns, :rows, :format_id, :esc_sequence, :aspect_ratio, $

      def width=(width)
        @width = width || 0
      end

                def orientation=(orienta)
                        @orientation = orienta || "N"
                end

      def height_of_symbol=(height)
        @height_of_symbol = height
      end

      def quality_level=(level)
        @quality_level = level
      end

                def to_zpl
                        "^FW#{rotation}^FO#{x},#{y}^BX#{@orientation},#{@height_of_symbol},#{@quality_level},#{columns},#{rows},#{format$
                end
        end
  end
end
