module Zebra
  module Zpl
    module Rotation
      class InvalidRotationError < StandardError; end

      NO_ROTATION = 0
      DEGREES_90  = 1
      DEGREES_180 = 2
      DEGREES_270 = 3

      def self.valid_rotation?(rotation)
        [NO_ROTATION, DEGREES_90, DEGREES_180, DEGREES_270].include? rotation
      end

      def self.validate_rotation(rotation)
        raise InvalidRotationError unless valid_rotation?(rotation)
      end
    end
  end
end
