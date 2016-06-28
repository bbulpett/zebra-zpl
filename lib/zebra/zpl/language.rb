# encoding: utf-8
module Zebra
  module Zpl
    class Language
      class InvalidLanguageError                    < StandardError; end
      class InvalidLanguageForNumberOfDataBitsError < StandardError; end

      # 8 bits languages
      ENGLISH_US       = "0"
      LATIN_1          = "1"
      LATIN_2          = "2"
      PORTUGUESE       = "3"
      FRENCH_CANADIAN  = "4"
      NORDIC           = "5"
      TURKISH          = "6"
      ICELANDIC        = "7"
      HEBREW           = "8"
      CYRILLIC         = "9"
      CYRILLIC_CIS_1   = "10"
      GREEK            = "11"
      GREEK_1          = "12"
      GREEK_2          = "13"
      LATIN_1_WINDOWS  = "A"
      LATIN_2_WINDOWS  = "B"
      CYRILLIC_WINDOWS = "C"
      GREEK_WINDOWS    = "D"
      TURKISH_WINDOWS  = "E"
      HEBREW_WINDOWS   = "F"

      # 7 bits languages
      USA              = "0"
      BRITISH          = "1"
      GERMAN           = "2"
      FRENCH           = "3"
      DANISH           = "4"
      ITALIAN          = "5"
      SPANISH          = "6"
      SWEDISH          = "7"
      SWISS            = "8"

      def self.valid_language?(language)
        ("0".."13").include?(language) || ("A".."F").include?(language)
      end

      def self.validate_language(language)
        raise InvalidLanguageError unless valid_language?(language)
      end

      def self.validate_language_for_number_of_data_bits(language, number_of_data_bits)
        if number_of_data_bits == 8
          validate_8_data_bits_language language
        elsif number_of_data_bits == 7
          validate_7_data_bits_language language
        else
          raise ArgumentError.new("Unknown number of data bits")
        end
      end

      private

      def self.validate_8_data_bits_language(language)
        raise InvalidLanguageForNumberOfDataBitsError unless [ENGLISH_US,
        LATIN_1, LATIN_2, PORTUGUESE, FRENCH_CANADIAN, NORDIC,
        TURKISH, ICELANDIC, HEBREW, CYRILLIC, CYRILLIC_CIS_1, GREEK,
        GREEK_1, GREEK_2, LATIN_1_WINDOWS, LATIN_2_WINDOWS, CYRILLIC_WINDOWS,
        GREEK_WINDOWS, TURKISH_WINDOWS, HEBREW_WINDOWS].include?(language)
      end

      def self.validate_7_data_bits_language(language)
        raise InvalidLanguageForNumberOfDataBitsError unless [USA, BRITISH,
        GERMAN, FRENCH, DANISH, ITALIAN, SPANISH, SWEDISH, SWISS].include?(language)
      end
    end
  end
end

