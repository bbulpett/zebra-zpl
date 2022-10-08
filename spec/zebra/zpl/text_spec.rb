# encoding: utf-8
require 'spec_helper'

describe Zebra::Zpl::Text do
  it "can be initialized with the position of the text to be printed" do
    text = described_class.new position: [20, 40]
    expect(text.position).to eq [20,40]
    expect(text.x).to eq 20
    expect(text.y).to eq 40
  end

  it "can be initialized with the text rotation" do
    rotation = Zebra::Zpl::Rotation::DEGREES_90
    text = described_class.new rotation: rotation
    expect(text.rotation).to eq rotation
  end

  it "can be initialized with the font_size to be used" do
    font_size = Zebra::Zpl::FontSize::SIZE_1
    text = described_class.new font_size: font_size
    expect(text.font_size).to eq font_size
  end

  it "can be initialized with the data to be printed" do
    data = "foobar"
    text = described_class.new data: data
    expect(text.data).to eq data
  end

  it "can be initialized with the reverse_print" do
    text = described_class.new reverse_print: true
    expect(text.reverse_print).to eq true
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
        described_class.new.font_size = -1
      }.to raise_error(Zebra::Zpl::FontSize::InvalidFontSizeError)
      expect {
        described_class.new.font_size = 32001
      }.to raise_error(Zebra::Zpl::FontSize::InvalidFontSizeError)
    end
  end

  describe "#to_zpl" do
    subject(:text) { described_class.new position: [100, 150], font_size: Zebra::Zpl::FontSize::SIZE_3, data: "foobar" }
    subject(:text_bold) { described_class.new position: [100, 150], font_size: Zebra::Zpl::FontSize::SIZE_3, bold: true, data: "foobar" }
    subject(:tokens) { text.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

    it "raises an error if the X position was not informed" do
      text = described_class.new position: [nil, 100], data: "foobar"
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      text = described_class.new position: [100, nil]
      expect {
        text.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the font_size is not informed" do
      text = described_class.new position: [100, 100], data: "foobar"
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

    it "contains the '^FB' command" do
      expect(text.to_zpl).to match /\^FB/
    end

    it "contains the attributes in correct order" do
      expect(text.to_zpl).to eq '^FWN^A0,28^CI28^FO100,150^FB,4,,L,^FDfoobar^FS'
    end

    it "contains the properly duplicated attributes in correct order for bold text" do
      expect(text_bold.to_zpl).to eq '^FWN^A0,28^CI28^FO101,150^FB,4,,L,^FDfoobar^FS^FWN^A0,28^CI28^FO100,151^FB,4,,L,^FDfoobar^FS'
    end

    it 'contains reverse print field on reverse_print mode' do
      text = described_class.new position: [100, 100], font_size: Zebra::Zpl::FontSize::SIZE_3, data: "foobar", reverse_print: true

      expect(text.to_zpl).to match /\^FR/
    end

    it 'does not have reverse print field if not specified' do
      expect(text.to_zpl).to_not match /\^FR/
    end
  end
end
