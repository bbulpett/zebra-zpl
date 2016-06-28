module Zebra
  module Zpl
    module Rotation
      class InvalidRotationError < StandardError; end

      NO_ROTATION = 'N'
      DEGREES_90  = 'R'
      DEGREES_180 = 'I'
      DEGREES_270 = 'B'

      def self.valid_rotation?(rotation)
        [NO_ROTATION, DEGREES_90, DEGREES_180, DEGREES_270].include? rotation
      end

      def self.validate_rotation(rotation)
        raise InvalidRotationError unless valid_rotation?(rotation)
      end
    end
  end
end
