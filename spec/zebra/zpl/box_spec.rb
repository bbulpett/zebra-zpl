# encoding: utf-8
require 'spec_helper'

describe Zebra::Zpl::Box do
  it "can be initialized with initial position" do
    box = described_class.new :position => [20, 40]
    expect(box.position).to eq([20, 40])
    expect(box.x).to eq(20)
    expect(box.y).to eq(40)
  end

  it "can be initialized with the line thckness " do
    box = described_class.new :line_thickness => 3
    expect(box.line_thickness).to eq 3
  end

  describe "#to_zpl" do
    subject(:box)    { described_class.new attributes }
    let(:attributes) { { position: [20, 40], line_thickness: 3, box_width: 100, box_height: 100 } }

    it "raises an error if the X position was not informed" do
      box = described_class.new attributes.merge :position => [nil, 40]
      expect {
        box.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      box = described_class.new attributes.merge :position => [20, nil]
      expect {
        box.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the line thickness was not informed" do
      box = described_class.new attributes.merge :line_thickness => nil
      expect {
        box.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the line thickness is not given")
    end

    it "contains the '^GB' command" do
      expect(box.to_zpl).to include("^GB")
    end

    it "contains the attributes in correct order" do
      expect(box.to_zpl).to eq("^FO20,40^GB100,100,3^FS")
    end
  end
end
