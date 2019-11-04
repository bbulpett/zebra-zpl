require 'spec_helper'

describe Zebra::Zpl::Datamatrix do
    it "can be initialized with the symbol height" do
      datamatrix = described_class.new symbol_height: 3
      expect(datamatrix.symbol_height).to eq 3
    end

    it "can be initialized with a quality level" do
      datamatrix = described_class.new quality: 140
      expect(datamatrix.quality).to eq 140
    end

    it "can be initialized with a number of columns" do
      datamatrix = described_class.new columns: 33
      expect(datamatrix.columns).to eq 33
    end

    it "can be initialized with a number of rows" do
      datamatrix = described_class.new rows: 42
      expect(datamatrix.rows).to eq 42
    end

    it "can be initialized with a format" do
      datamatrix = described_class.new format: 2
      expect(datamatrix.format).to eq 2
    end
    it "can be initialized with a aspect ratio" do
      datamatrix = described_class.new aspect_ratio: 2
      expect(datamatrix.aspect_ratio).to eq 2
    end

    describe "#orientation" do
      it "raises an error if the orientation not in [N I R B]" do
        expect { described_class.new orientation: 'A' }.to raise_error(Zebra::Zpl::Datamatrix::InvalidOrientationError)
      end
    end

    describe "#quality" do
      it "raises an error if the quality is not one of 0, 50, 80, 100, 140, 200" do
        expect { described_class.new quality: 20 }.to raise_error(Zebra::Zpl::Datamatrix::InvalidQualityFactorError)
      end
    end

    describe "#columns" do
      it "raises an error if the number of columns is out of bounds" do
        expect { described_class.new columns: 0 }.to raise_error(Zebra::Zpl::Datamatrix::InvalidSizeError)
      end
    end

    describe "#rows" do
      it "raises an error if the number of rows is out of bounds" do
        expect { described_class.new rows: 59 }.to raise_error(Zebra::Zpl::Datamatrix::InvalidSizeError)
      end
    end


    describe "#to_zpl" do
      let(:valid_attributes) { {
        position:         [50, 50],
        symbol_height:     5,
        data:             "foobar"
      }}
      let(:datamatrix) { described_class.new valid_attributes }
      let(:tokens) { datamatrix.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

      it "raises an error if the X position is not given" do
        datamatrix = described_class.new position: [nil, 50], data: "foobar"
        expect {
          datamatrix.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
      end

      it "raises an error if the Y position is not given" do
        datamatrix = described_class.new position: [50, nil], data: "foobar"
        expect {
          datamatrix.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
      end

      it "raises an error if the data to be printed was not informed" do
        datamatrix.data = nil
        expect {
          datamatrix.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
      end

      it "raises an error if the scale factor is not given" do
        valid_attributes.delete :symbol_height

        expect {
          datamatrix.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the symbol height to be used is not given")
      end

      it "contains the barcode command '^B'" do
        expect(datamatrix.to_zpl).to match /\^B/
      end

      it "contains the X position" do
        expect(tokens[2]).to eq "50"
      end

      it "contains the Y position" do
        expect(tokens[3]).to eq "50"
      end

      it "contains Data Matrix code type" do
        expect(tokens[6]).to eq "^BXN"
      end

      it "contains the symbol_height" do
        expect(tokens[7]).to eq "5"
      end

      it "contains the quality level" do
        expect(tokens[8]).to eq "200"
      end

      it "contains the data to be printed in the datamatrix" do
        expect(tokens[10]).to eq "foobar"
      end
  end
end
