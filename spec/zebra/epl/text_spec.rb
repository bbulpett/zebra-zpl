# encoding: utf-8
require 'spec_helper'

describe Zebra::Epl::Text do
  it "can be initialized with the position of the text to be printed" do
    text = described_class.new :position => [20, 40]
    text.position.should == [20,40]
    text.x.should == 20
    text.y.should == 40
  end

  it "can be initialized with the text rotation" do
    rotation = Zebra::Epl::Rotation::DEGREES_90
    text = described_class.new :rotation => rotation
    text.rotation.should == rotation
  end

  it "can be initialized with the font to be used" do
    font = Zebra::Epl::Font::SIZE_1
    text = described_class.new :font => font
    text.font.should == font
  end

  it "can be initialized with the horizontal multiplier" do
    multiplier = Zebra::Epl::HorizontalMultiplier::VALUE_1
    text = described_class.new :h_multiplier => multiplier
    text.h_multiplier.should == multiplier
  end

  it "can be initialized with the vertical multiplier" do
    multiplier = Zebra::Epl::VerticalMultiplier::VALUE_1
    text = described_class.new :v_multiplier => multiplier
    text.v_multiplier.should == multiplier
  end

  it "can be initialized with the data to be printed" do
    data = "foobar"
    text = described_class.new :data => data
    text.data.should == data
  end

  it "can be initialized with the printing mode" do
    print_mode = Zebra::Epl::PrintMode::REVERSE
    text = described_class.new :print_mode => print_mode
    text.print_mode.should == print_mode
  end

  describe "#rotation=" do
    it "raises an error if the received rotation is invalid" do
      expect {
        described_class.new.rotation = 4
      }.to raise_error(Zebra::Epl::Rotation::InvalidRotationError)
    end
  end

  describe "#font=" do
    it "raises an error if the received font is invalid" do
      expect {
        described_class.new.font = 6
      }.to raise_error(Zebra::Epl::Font::InvalidFontError)
    end
  end

  describe "#h_multiplier=" do
    it "raises an error if the received multiplier is invalid" do
      expect {
        described_class.new.h_multiplier = 9
      }.to raise_error(Zebra::Epl::HorizontalMultiplier::InvalidMultiplierError)
    end
  end

  describe "#v_multiplier=" do
    it "raises an error if the received multiplier is invalid" do
      expect {
        described_class.new.v_multiplier = 10
      }.to raise_error(Zebra::Epl::VerticalMultiplier::InvalidMultiplierError)
    end
  end

  describe "#print_mode=" do
    it "raises an error if the received print mode is invalid" do
      expect {
        described_class.new.print_mode = "foo"
      }.to raise_error(Zebra::Epl::PrintMode::InvalidPrintModeError)
    end
  end

  describe "#to_epl" do
    subject(:text) { described_class.new :position => [100, 150], :font => Zebra::Epl::Font::SIZE_3, :data => "foobar" }

    it "raises an error if the X position was not informed" do
      text = described_class.new :position => [nil, 100], :data => "foobar"
      expect {
        text.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      text = described_class.new :position => [100, nil]
      expect {
        text.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the font is not informed" do
      text = described_class.new :position => [100, 100], :data => "foobar"
      expect {
        text.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the font to be used is not given")
    end

    it "raises an error if the data to be printed was not informed" do
      text.data = nil
      expect {
        text.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
    end

    it "begins width the 'A' command" do
      text.to_epl.should =~ /\AA/
    end

    it "assumes 1 as the default horizontal multipler" do
      text.to_epl.split(",")[4].to_i.should == Zebra::Epl::HorizontalMultiplier::VALUE_1
    end

    it "assumes 1 as the default vertical multiplier" do
      text.to_epl.split(",")[5].to_i.should == Zebra::Epl::VerticalMultiplier::VALUE_1
    end

    it "assumes the normal print mode as the default" do
      text.to_epl.split(",")[6].should == Zebra::Epl::PrintMode::NORMAL
    end

    it "assumes no rotation by default" do
      text.to_epl.split(",")[2].to_i.should == Zebra::Epl::Rotation::NO_ROTATION
    end
  end
end
