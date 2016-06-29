module Zebra
  module Zpl
    module Justification
      class InvalidJustificationError < StandardError; end

      # ZPL-supported values ("L" is default)
      LEFT        = 'L'
      RIGHT       = 'R'
      CENTER      = 'C'
      JUSTIFIED   = 'J'

      def self.valid_justification?(justification)
        [LEFT, RIGHT, CENTER, JUSTIFIED].include? justification
      end

      def self.validate_justification(justification)
        raise InvalidJustificationError unless valid_justification?(justification)
      end
    end
  end
end
