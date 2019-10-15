require "zebra/zpl/printable"

module Zebra
  module Zpl
    class Comment
      include Printable
      attr_accessor :comment

      def to_zpl
        check_attributes
        "^FX#{comment}^FS"
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
