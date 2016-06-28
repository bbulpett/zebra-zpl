require 'spec_helper'

describe Zebra::Zpl::Barcode do
  it "can be initialized with the position of the text to be printed" do
    barcode = described_class.new :position => [20, 40]
    barcode.position.should == [20,40]
    barcode.x.should == 20
    barcode.y.should == 40
  end

  it "can be initialized with the barcode rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    barcode = described_class.new :rotation => rotation
    barcode.rotation.should == rotation
  end

  it "can be initialized with the barcode rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    barcode = described_class.new :rotation => rotation
    barcode.rotation.should == rotation
  end

  it "can be initialized with the barcode type" do
    type = Zebra::Zpl::BarcodeType::CODE_128_C
    barcode = described_class.new :type => type
    barcode.type.should == type
  end

  it "can be initialized with the narrow bar width" do
    barcode = described_class.new :narrow_bar_width => 3
    barcode.narrow_bar_width.should == 3
  end

  it "can be initialized with the wide bar width" do
    barcode = described_class.new :wide_bar_width => 10
    barcode.wide_bar_width.should == 10
  end

  it "can be initialized with the barcode height" do
    barcode = described_class.new :height => 20
    barcode.height.should == 20
  end

  it "can be initialized informing if the human readable code should be printed" do
    barcode = described_class.new :print_human_readable_code => true
    barcode.print_human_readable_code.should == true
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
        described_class.new :type => Zebra::Zpl::BarcodeType::CODE_128_AUTO, :narrow_bar_width => 20
      }.to raise_error(Zebra::Zpl::Barcode::InvalidNarrowBarWidthError)
    end
  end

  describe "#wide_bar_width=" do
    it "raises an error if the type is Code 128 and the width is invalid" do
      expect {
        described_class.new :type => Zebra::Zpl::BarcodeType::CODE_128_AUTO, :wide_bar_width => 40
      }.to raise_error(Zebra::Zpl::Barcode::InvalidWideBarWidthError)
    end
  end

  describe "#print_human_readable_code" do
    it "defaults to false" do
      described_class.new.print_human_readable_code.should == false
    end
  end

  describe "#to_zpl" do
    let(:valid_attributes) { {
      :position         => [100, 150],
      :type             => Zebra::Zpl::BarcodeType::CODE_128_AUTO,
      :height           => 20,
      :narrow_bar_width => 4,
      :wide_bar_width   => 6,
      :data             => "foobar"
    } }
    let(:barcode) { described_class.new valid_attributes }
    let(:tokens) { barcode.to_zpl.split(",") }

    it "raises an error if the X position was not informed" do
      barcode = described_class.new :position => [nil, 100], :data => "foobar"
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      barcode = described_class.new :position => [100, nil]
      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the barcode type is not informed" do
      barcode = described_class.new :position => [100, 100], :data => "foobar"
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

    it "raises an error if the narrow bar width is not given" do
      valid_attributes.delete :narrow_bar_width

      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the narrow bar width to be used is not given")
    end

    it "raises an error if the wide bar width is not given" do
      valid_attributes.delete :wide_bar_width

      expect {
        barcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the wide bar width to be used is not given")
    end

    it "begins with the command 'B'" do
      barcode.to_zpl.should =~ /\AB/
    end

    it "contains the X position" do
      tokens[0].match(/B(\d+)/)[1].should == "100"
    end

    it "contains the Y position" do
      tokens[1].should == "150"
    end

    it "contains the barcode rotation" do
      tokens[2].should == Zebra::Zpl::Rotation::NO_ROTATION.to_s
    end

    it "contains the barcode type" do
      tokens[3].should == Zebra::Zpl::BarcodeType::CODE_128_AUTO
    end

    it "contains the barcode narrow bar width" do
      tokens[4].should == "4"
    end

    it "contains the barcode wide bar width" do
      tokens[5].should == "6"
    end

    it "contains the barcode height" do
      tokens[6].should == "20"
    end

    it "contains the correct indication when the human readable code should be printed" do
      valid_attributes.merge! :print_human_readable_code => true
      tokens[7].should == "B"
    end

    it "contains the correct indication when the human readable code should not be printed" do
      valid_attributes.merge! :print_human_readable_code => false
      tokens[7].should == "N"
    end

    it "contains the data to be printed in the barcode" do
      tokens[8].should == "\"foobar\""
    end
  end
end
