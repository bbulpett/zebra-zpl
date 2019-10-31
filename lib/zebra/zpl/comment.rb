module Zebra
  module Zpl
    class Comment
      attr_accessor :data

      def initialize(options = {})
        options.each_pair { |attribute, value| self.__send__ "#{attribute}=", value }
      end

      def to_zpl
        "^FX#{data}^FS"
      end
    end
  end
end
