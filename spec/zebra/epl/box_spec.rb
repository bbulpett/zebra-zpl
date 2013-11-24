# encoding: utf-8
require 'spec_helper'

describe Zebra::Epl::Box do
  it "can be initialized with initial position" do
    box = described_class.new :position => [20, 40]
    box.position.should == [20, 40]
    box.x.should == 20
    box.y.should == 40
  end

  it "can be initialized with the end position" do
    box = described_class.new :end_position => [20, 40]
    box.end_position.should == [20, 40]
    box.end_x.should == 20
    box.end_y.should == 40
  end

  it "can be initialized with the line thckness " do
    box = described_class.new :line_thickness => 3
    box.line_thickness.should == 3
  end

  describe "#to_epl" do
    subject(:box)    { described_class.new attributes }
    let(:attributes) { { :position => [20,40], :end_position => [60, 100], :line_thickness => 3 }  }

    it "raises an error if the X position was not informed" do
      box = described_class.new attributes.merge :position => [nil, 40]
      expect {
        box.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it "raises an error if the Y position was not informed" do
      box = described_class.new attributes.merge :position => [20, nil]
      expect {
        box.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it "raises an error if the end X position was not informed" do
      box = described_class.new attributes.merge :end_position => [nil, 40]
      expect {
        box.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the horizontal end position (X) is not given")
    end

    it "raises an error if the end Y position was not informed" do
      box = described_class.new attributes.merge :end_position => [20, nil]
      expect {
        box.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the vertical end position (Y) is not given")
    end

    it "raises an error if the line thickness was not informed" do
      box = described_class.new attributes.merge :line_thickness => nil
      expect {
        box.to_epl
      }.to raise_error(Zebra::Epl::Printable::MissingAttributeError, "Can't print if the line thickness is not given")
    end

    it "begins with the 'X' command" do
      box.to_epl.should =~ /\AX/
    end

    it "contains the attributes in correct order" do
      box.to_epl.should == "X20,40,3,60,100"
    end
  end
end
