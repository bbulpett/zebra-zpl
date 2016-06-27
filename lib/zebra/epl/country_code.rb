# encoding: utf-8
module Zebra
  module Zpl
    class CountryCode
      class InvalidCountryCodeError < StandardError; end

      BELGIUM       = "032"
      CANADA        = "002"
      DENMARK       = "045"
      FINLAND       = "358"
      FRANCE        = "033"
      GERMANY       = "049"
      NETHERLANDS   = "031"
      ITALY         = "039"
      LATIN_AMERICA = "003"
      NORWAY        = "047"
      PORTUGAL      = "351"
      SOUTH_AFRICA  = "027"
      SPAIN         = "034"
      SWEDEN        = "046"
      SWITZERLAND   = "041"
      UK            = "044"
      USA           = "001"

      def self.valid_country_code?(code)
        [BELGIUM, CANADA, DENMARK, FINLAND, FRANCE, GERMANY, NETHERLANDS,
         ITALY, LATIN_AMERICA, NORWAY, PORTUGAL, SOUTH_AFRICA, SPAIN, SWEDEN, SWITZERLAND,
         UK, USA].include?(code)
      end

      def self.validate_country_code(code)
        raise InvalidCountryCodeError unless valid_country_code?(code)
      end
    end
  end
end
