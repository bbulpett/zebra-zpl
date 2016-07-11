module Zebra
  module Zpl
    module Printable
      class MissingAttributeError < StandardError
        def initialize(message)
          super("Can't print if #{message}")
        end
      end

      attr_reader :position, :x, :y, :margin
      attr_accessor :data

      def initialize(options = {})
        options.each_pair { |attribute, value| self.__send__ "#{attribute}=", value }
      end

      def position=(coords)
        @position = coords
        @x = (@margin.nil? || @margin == 0) ? coords[0] : (@margin + coords[0])
        @y = coords[1]
      end

      def justification=(just)
        Justification.validate_justification just
        @justification = just
      end

      def justification
        @justification || Justification::LEFT
      end

      def margin=(margin)
        @margin = margin || 0
      end

      def rotation=(rot)
        Rotation.validate_rotation rot
        @rotation = rot
      end

      def rotation
        @rotation || Rotation::NO_ROTATION
      end

      private

      def has_data?
        true
      end

      def check_attributes
        raise MissingAttributeError.new("the X value is not given") unless @x
        raise MissingAttributeError.new("the Y value is not given") unless @y
        raise MissingAttributeError.new("the data to be printed is not given") unless @data || !has_data?
      end
    end
  end
end
