module Zebra
  module Epl
    module BaseMultiplier
      class InvalidMultiplierError < StandardError; end

      VALUE_1 = 1
      VALUE_2 = 2
      VALUE_3 = 3
      VALUE_4 = 4
      VALUE_5 = 5
      VALUE_6 = 6
      VALUE_7 = 7
      VALUE_8 = 8

      def self.included(base_module)
        base_module.instance_eval do
          def validate_multiplier(multiplier)
            raise InvalidMultiplierError unless valid_multiplier?(multiplier)
          end
        end
      end
    end

    module HorizontalMultiplier
      include BaseMultiplier

      def self.valid_multiplier?(multiplier)
        (1..8).include? multiplier
      end
    end

    module VerticalMultiplier
      include BaseMultiplier

      VALUE_9 = 9

      def self.valid_multiplier?(multiplier)
        (1..9).include? multiplier
      end
    end
  end
end
