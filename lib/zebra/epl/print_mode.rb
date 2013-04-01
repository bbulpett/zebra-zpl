module Zebra
  module Epl
    module PrintMode
      class InvalidPrintModeError < StandardError; end

      NORMAL  = "N"
      REVERSE = "R"

      def self.valid_mode?(mode)
        %w(N R).include? mode
      end

      def self.validate_mode(mode)
        raise InvalidPrintModeError unless valid_mode?(mode)
      end
    end
  end
end
