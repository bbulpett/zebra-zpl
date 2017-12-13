# encoding: utf-8
require 'spec_helper'

describe Zebra::Zpl::Text do
  it "can be initialized with the position of the text to be printed" do
    text = described_class.new :position => [20, 40]
    expect(text.position).to eq([20,40])
    expect(text.x).to eq(20)
    expect(text.y).to eq(40)
  end

  it "can be initialized with the text rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    text = described_class.new :rotation => rotation
    expect(text.rotation).to eq(rotation)
  end

  it "can be initialized with the font_size to be used" do
    font_size = Zebra::Zpl::FontSize::SIZE_1
    text = described_class.new :font_size => font_size
    expect(text.font_size).to eq(font_size)
  end

  it "can be initialized with the data to be printed" do
    data = "foobar"
    text = described_class.new :data => data
    expect(text.data).to eq(data)
  end

  describe "#rotation=" do
    it "raises an error if the received rotation is invalid" do
      expect {
        described_class.new.rotation = 4
      }.to raise_error(Zebra::Zpl::Rotation::InvalidRotationError)
    end
  end

  describe "#font_size=" do
    it "raises an error if the received font_size is invalid" do
      expect {
        described_class.new.font_size = 6
      }.to raise_error(Zebra::Zpl::FontSize::InvalidFontSizeError)
    end
  end

  describe "#to_zpl" do
    subject(:text) { described_class.new :position => [100, 150], :font_size => Zebra::Zpl::FontSize::SIZE_3, :data => "foobar" }

    it "raises an error if the X position was not informed" do
      text = described_class.new :position => [nil, 100], :data => "foobar"
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      text = described_class.new :position => [100, nil]
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the font_size is not informed" do
      text = described_class.new :position => [100, 100], :data => "foobar"
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the font_size to be used is not given")
    end

    it "raises an error if the data to be printed was not informed" do
      text.data = nil
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the data to be printed is not given")
    end

    it "begins width the 'A' command" do
      expect(text.to_zpl).to match(/\^FWN/)
    end

    it "assumes no rotation by default" do
      puts text.to_zpl.split(",")[0]
      expect(text.to_zpl.split(",")[0]).to eq("^FW#{Zebra::Zpl::Rotation::NO_ROTATION}^CF0")
    end
  end
end
