require 'spec_helper'

describe Zebra::Zpl::Barcode do
  it "can be initialized with the position of the text to be printed" do
    barcode = described_class.new position: [20, 40]
    expect(barcode.position).to eq [20,40]
    expect(barcode.x).to eq 20
    expect(barcode.y).to eq 40
  end

  it "can be initialized with the barcode rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    barcode = described_class.new rotation: rotation
    expect(barcode.rotation).to eq rotation
  end

  it "can be initialized with the barcode rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    barcode = described_class.new rotation: rotation
    expect(barcode.rotation).to eq rotation
  end

  it "can be initialized with the barcode type" do
    type = Zebra::Zpl::BarcodeType::CODE_128_AUTO
    barcode = described_class.new type: type
    expect(barcode.type).to eq type
  end

  it "can be initialized with the barcode width" do
    barcode = described_class.new width: 5
    expect(barcode.width).to eq 5
  end

  it "can be initialized with the barcode height" do
    barcode = described_class.new height: 20
    expect(barcode.height).to eq 20
  end

  it "can be initialized with the ratio" do
    barcode = described_class.new ratio: 3.0
    expect(barcode.ratio).to eq 3.0
  end

  it "can be initialized with the narrow bar width" do
    barcode = described_class.new narrow_bar_width: 3
    expect(barcode.narrow_bar_width).to eq 3
  end

  it "can be initialized with the wide bar width" do
    barcode = described_class.new wide_bar_width: 10
    expect(barcode.wide_bar_width).to eq 10
  end

  it "can be initialized informing if the human readable code should be printed" do
    barcode = described_class.new print_human_readable_code: true
    expect(barcode.print_human_readable_code).to eq true
  end

  describe "#rotation=" do
    it "raises an error if the received rotation is invalid" do
      expect {
        described_class.new.rotation = 4
      }.to raise_error(Zebra::Zpl::Rotation::InvalidRotationError)
    end
  end

  describe "#type=" do
    it "raises an error if the received type is invalid" do
      expect {
        described_class.new.type = "ZZZ"
      }.to raise_error(Zebra::Zpl::BarcodeType::InvalidBarcodeTypeError)
    end
  end

  describe "#narrow_bar_width=" do
    it "raises an error if the type is Code 128 and the width is invalid" do
      expect {
        described_class.new type: Zebra::Zpl::BarcodeType::CODE_128_AUTO, narrow_bar_width: 20
      }.to raise_error(Zebra::Zpl::Barcode::InvalidNarrowBarWidthError)
    end
  end

  describe "#wide_bar_width=" do
    it "raises an error if the type is Code 128 and the width is invalid" do
      expect {
        described_class.new type: Zebra::Zpl::BarcodeType::CODE_128_AUTO, wide_bar_width: 40
      }.to raise_error(Zebra::Zpl::Barcode::InvalidWideBarWidthError)
    end
  end

  describe "#print_human_readable_code" do
    it "defaults to false" do
      expect(described_class.new.print_human_readable_code).to eq false
    end
  end

  describe "#to_zpl" do
    let(:valid_attributes) { {
      position:         [100, 150],
      type:             Zebra::Zpl::BarcodeType::CODE_128_AUTO,
      height:           20,
      width:            5,
      narrow_bar_width: 3,
      wide_bar_width:   6,
      data:             "foobar"
    } }
    let(:barcode) { described_class.new valid_attributes }
    let(:tokens) { barcode.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

    it "raises an error if the X position was not informed" do
      barcode = described_class.new position: [nil, 100], data: "foobar"
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      barcode = described_class.new position: [100, nil]
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the barcode type is not informed" do
      barcode = described_class.new position: [100, 100], data: "foobar"
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the barcode type to be used is not given")
    end

    it "raises an error if the data to be printed was not informed" do
      barcode.data = nil
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
    end

    it "raises an error if the height to be used was not informed" do
      barcode.height = nil
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the height to be used is not given")
    end

    it "raises an error if the neither of with, narrow_bar_width, or wide_bar_width are not given" do
      valid_attributes.delete :width
      valid_attributes.delete :narrow_bar_width
      valid_attributes.delete :wide_bar_width
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the width to be used is not given")
    end

    it "begins with the command 'B'" do
      expect(tokens[4]).to eq '^BY'
    end

    it "contains the X position" do
      expect(tokens[2]).to eq '100'
    end

    it "contains the Y position" do
      expect(tokens[3]).to eq '150'
    end

    it "contains the width" do
      expect(tokens[5]).to eq '5'
    end

    it "contains the ratio" do
      expect(tokens[6]).to eq '2.0'
    end

    it "contains the barcode height" do
      expect(tokens[7]).to eq '20'
    end

    it "contains the barcode type" do
      expect(tokens[8]).to start_with "^B#{Zebra::Zpl::BarcodeType::CODE_128_AUTO}"
    end

    it "contains the barcode rotation" do
      expect(tokens[0]).to start_with '^FW'
      expect(tokens[0]).to end_with Zebra::Zpl::Rotation::NO_ROTATION.to_s
      expect(tokens[8]).to start_with '^B'
      expect(tokens[8]).to end_with Zebra::Zpl::Rotation::NO_ROTATION.to_s
    end

    it "contains the correct indication when the human readable code should be printed" do
      valid_attributes.merge! print_human_readable_code: true
      expect(tokens[9]).to eq 'Y'
    end

    it "contains the correct indication when the human readable code should not be printed" do
      valid_attributes.merge! print_human_readable_code: false
      expect(tokens[9]).to eq 'N'
    end

    it "contains the data to be printed in the barcode" do
      expect(tokens[11]).to eq 'foobar'
    end
  end
end
