require 'spec_helper'

describe Zebra::Zpl::PDF417 do
    it "can be initialized with row height" do
      pdf417 = described_class.new :row_height => 3
      expect(pdf417.row_height).to eq 3
    end

    it "can be initialized with the security level" do
      pdf417 = described_class.new :security_level => 1
      expect(pdf417.security_level).to eq 1
    end

    it "can be initialized with truncate" do
        pdf417 = described_class.new :truncate => "Y"
        expect(pdf417.truncate).to eq "Y"
    end

    it "can be initialized with column number" do
        pdf417 = described_class.new :column_number => 5
        expect(pdf417.column_number).to eq 5
    end

    it "can be initialized with row number" do
        pdf417 = described_class.new :row_number => 10
        expect(pdf417.row_number).to eq 10
    end

    describe "#column_number" do
      it "raises an error if the column number is not within the range 1-30" do
        expect{described_class.new :column_number=>50}.to raise_error(Zebra::Zpl::PDF417::InvalidRowColumnNumberError)
      end
    end

    describe "#row_number" do
      it "raises an error if the row number is not within the range 3-90" do
        expect{described_class.new :row_number=>95}.to raise_error(Zebra::Zpl::PDF417::InvalidRowColumnNumberError)
      end
    end

    describe "#to_zpl" do
      let(:valid_attributes) { {
        :data           => ("Do away with it!"),
        :position       => [50, 50],
        :row_height     => 5,
        :row_number     => 30,
        :column_number  => 15,
        :rotation       => "N",
        :security_level => 5,
        :truncate       => "N"
      }}
      let(:pdf417) { described_class.new valid_attributes }
      let(:tokens) { pdf417.to_zpl.split(",") }

      it "raises an error if the X position is not given" do
        pdf417 = described_class.new :position => [nil, 50], :data => "foobar"
        expect {
          pdf417.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
      end

      it "raises an error if the Y position is not given" do
        pdf417 = described_class.new :position => [50, nil], :data => "foobar"
        expect {
          pdf417.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
      end

      it "raises an error if the data to be printed was not informed" do
        pdf417.data = nil
        expect {
          pdf417.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
      end

      it "contains the X position" do
        expect(tokens[0].match(/FO(\d+)/)[1]).to eq "50"
      end

      it "contains the Y position" do
        expect(tokens[1].match(/(\d+)\^/)[1]).to eq "50"
      end

      it "contains the row height" do
        expect(tokens[4]).to eq "5"
      end

      it "contains the security level" do
        expect(tokens[5]).to eq "5"
      end

      it "contains the column number" do
        expect(tokens[6]).to eq "15"
      end

      it "contains the row number" do
        expect(tokens[7]).to eq "30"
      end

      it "contains the trucate option" do
        expect(tokens[8].match(/(\w) \^/)[1]).to eq "N"
      end

      it "contains the data to be printed in the pdf417 barcode" do
        expect(tokens[8].include?("Do away with it!")).to eq true
      end
  end
end
