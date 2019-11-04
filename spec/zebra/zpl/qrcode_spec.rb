require 'spec_helper'

describe Zebra::Zpl::Qrcode do
  it "can be initialized with the scale factor" do
    qrcode = described_class.new scale_factor: 3
    expect(qrcode.scale_factor).to eq 3
  end

  it "can be initialized with the error correction level" do
    qrcode = described_class.new correction_level: "M"
    expect(qrcode.correction_level).to eq "M"
  end

  describe "#scale_factor" do
    it "raises an error if the scale factor is not within the range 1-99" do
      expect { described_class.new scale_factor: 100 }.to raise_error(Zebra::Zpl::Qrcode::InvalidScaleFactorError)
    end
  end

  describe "#correction_level" do
    it "raises an error if the error correction_level not in [LMQH]" do
      expect { described_class.new correction_level: "A" }.to raise_error(Zebra::Zpl::Qrcode::InvalidCorrectionLevelError)
    end
  end

  describe "#to_zpl" do
    let(:valid_attributes) { {
      position:         [50, 50],
      scale_factor:     3,
      correction_level: "M",
      data:             "foobar"
    }}
    let(:qrcode) { described_class.new valid_attributes }
    let(:tokens) { qrcode.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

    it "raises an error if the X position is not given" do
      qrcode = described_class.new position: [nil, 50], data: "foobar"
      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position is not given" do
      qrcode = described_class.new position: [50, nil], data: "foobar"
      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the data to be printed was not informed" do
      qrcode.data = nil
      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
    end

    it "raises an error if the scale factor is not given" do
      valid_attributes.delete :scale_factor

      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the scale factor to be used is not given")
    end

    it "raises an error if the correction level is not given" do
      valid_attributes.delete :correction_level

      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the error correction level to be used is not given")
    end

    it "contains the barcode command '^B'" do
      expect(qrcode.to_zpl).to match /\^B/
    end

    it "contains the X position" do
      expect(tokens[2]).to eq "50"
    end

    it "contains the Y position" do
      expect(tokens[3]).to eq "50"
    end

    it "contains QR code type" do
      expect(tokens[6]).to eq "^BQN"
    end

    it "contains the scale factor" do
      expect(tokens[8]).to eq "3"
    end

    it "contains the error correction level" do
      expect(tokens[9]).to eq "3"
    end

    it "contains the data to be printed in the qrcode" do
      expect(tokens[11]).to eq "foobar"
    end
  end
end
