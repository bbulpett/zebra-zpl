# encoding: utf-8
module Zebra
  module Epl
    class CharacterSet
      class InvalidNumberOfDataBits                     < StandardError; end
      class CountryCodeNotApplicableForNumberOfDataBits < StandardError; end
      class MissingAttributeError                       < StandardError
        def initialize(attr)
          super("Can't set character set if the #{attr} is not given")
        end
      end

      attr_reader :number_of_data_bits, :language, :country_code

      def initialize(options = {})
        options.each_pair { |attribute, value| self.__send__ "#{attribute}=", value }
      end

      def number_of_data_bits=(nodb)
        raise InvalidNumberOfDataBits unless [7, 8, nil].include?(nodb)
        @number_of_data_bits = nodb
      end

      def language=(l)
        Language.validate_language(l) unless l.nil?
        @language = l
      end

      def country_code=(code)
        CountryCode.validate_country_code(code) unless code.nil?
        @country_code = code
      end

      def to_epl
        raise MissingAttributeError.new("language") if language.nil?
        raise MissingAttributeError.new("number of data bits") if number_of_data_bits.nil?
        raise MissingAttributeError.new("country code") if number_of_data_bits == 8 && country_code.nil?
        raise CountryCodeNotApplicableForNumberOfDataBits if number_of_data_bits == 7 && !country_code.nil?
        Language.validate_language_for_number_of_data_bits language, number_of_data_bits

        ["I#{number_of_data_bits}", language, country_code].compact.join(",")
      end
    end
  end
end
