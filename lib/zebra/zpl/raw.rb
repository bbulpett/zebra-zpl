require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Raw
      include Printable

      def to_zpl
        # check_attributes
        "^FW#{rotation}^FO#{x},#{y}#{data}^FS"
      end

      # private

      # def check_attributes
      #   super
      # end
    end
  end
end
