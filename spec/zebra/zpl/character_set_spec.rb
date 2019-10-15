require 'spec_helper'

describe Zebra::Zpl::CharacterSet do
  it "can be initialized with the number of data bits" do
    character_set = described_class.new :number_of_data_bits => 8
    expect(character_set.number_of_data_bits).to eq 8
  end

  it "raises an error when receiving an invalid number of data bits" do
    expect {
      described_class.new :number_of_data_bits => 9
    }.to raise_error(Zebra::Zpl::CharacterSet::InvalidNumberOfDataBits)
  end

  it "can be initialized with the language" do
    character_set = described_class.new :language => Zebra::Zpl::Language::PORTUGUESE
    expect(character_set.language).to eq Zebra::Zpl::Language::PORTUGUESE
  end

  it "raises an error with an invalid language" do
    expect {
      described_class.new :language => "G"
    }.to raise_error(Zebra::Zpl::Language::InvalidLanguageError)
  end

  it "can be initialized with the country code" do
    character_set = described_class.new :country_code => Zebra::Zpl::CountryCode::LATIN_AMERICA
    expect(character_set.country_code).to eq Zebra::Zpl::CountryCode::LATIN_AMERICA
  end

  it "raises an error with an invalid country code" do
    expect {
      described_class.new :country_code => "999"
    }.to raise_error(Zebra::Zpl::CountryCode::InvalidCountryCodeError)
  end

  describe "#to_zpl" do
    let(:valid_attributes) { {
      :number_of_data_bits => 8,
      :language            => Zebra::Zpl::Language::PORTUGUESE,
      :country_code        => Zebra::Zpl::CountryCode::LATIN_AMERICA
    } }
    let(:character_set) { described_class.new valid_attributes }
    let(:tokens) { character_set.to_zpl.split(",") }

    it "raises an error if the number of data bits was not informed" do
      character_set = described_class.new valid_attributes.merge :number_of_data_bits => nil
      expect {
        character_set.to_zpl
      }.to raise_error(Zebra::Zpl::CharacterSet::MissingAttributeError, "Can't set character set if the number of data bits is not given")
    end

    it "raises an error if the language was not informed" do
      character_set = described_class.new valid_attributes.merge :language => nil
      expect {
        character_set.to_zpl
      }.to raise_error(Zebra::Zpl::CharacterSet::MissingAttributeError, "Can't set character set if the language is not given")
    end

    it "raises an error if the country code was not informed and the number of bits is 8" do
      character_set = described_class.new valid_attributes.merge :country_code => nil
      expect {
        character_set.to_zpl
      }.to raise_error(Zebra::Zpl::CharacterSet::MissingAttributeError, "Can't set character set if the country code is not given")
    end

    it "raises an error if the country code was informed and the number of bits is 7" do
      character_set = described_class.new valid_attributes.merge :country_code => Zebra::Zpl::CountryCode::LATIN_AMERICA, :number_of_data_bits => 7
      expect {
        character_set.to_zpl
      }.to raise_error(Zebra::Zpl::CharacterSet::CountryCodeNotApplicableForNumberOfDataBits)
    end

    it "does not raise an error if the country code was not informed and the number of data bits is 7" do
      character_set = described_class.new :number_of_data_bits => 7, :language => Zebra::Zpl::Language::USA, :country_code => nil
    end

    it "raises an error if the language is not supported by the given number of data bits" do
      expect {
        described_class.new(:number_of_data_bits => 7, :language => Zebra::Zpl::Language::LATIN_1_WINDOWS).to_zpl
      }.to raise_error(Zebra::Zpl::Language::InvalidLanguageForNumberOfDataBitsError)
    end

    it "begins with the command 'I'" do
      expect(character_set.to_zpl).to match /\AI/
    end

    it "contains the number of data bits" do
      expect(tokens[0].match(/I(\d)/)[1]).to eq "8"
    end

    it "contains the language" do
      expect(tokens[1]).to eq Zebra::Zpl::Language::PORTUGUESE
    end

    it "contains the country code" do
      expect(tokens[2]).to eq Zebra::Zpl::CountryCode::LATIN_AMERICA
    end
  end
end
