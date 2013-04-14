# encoding: utf-8

require 'spec_helper'

describe Zebra::Epl::Label do
  subject(:label) { described_class.new :print_speed => 2 }

  describe "#new" do
    it "sets the label width" do
      label = described_class.new :width => 300
      label.width.should == 300
    end

    it "sets the label length/gap" do
      label = described_class.new :length_and_gap => [400, 24]
      label.length.should == 400
      label.gap.should    == 24
    end

    it "sets the printing speed" do
      label = described_class.new :print_speed => 2
      label.print_speed.should == 2
    end

    it "validates the printing speed" do
      [-1, 8, "a"].each do |s|
        expect {
          described_class.new :print_speed => s
        }.to raise_error(Zebra::Epl::Label::InvalidPrintSpeedError)
      end
    end

    it "sets the print density" do
      label = described_class.new :print_density => 10
      label.print_density.should == 10
    end

    it "validates the print density" do
      [-1, 16, "a"].each do |d|
        expect {
          described_class.new :print_density => d
        }.to raise_error(Zebra::Epl::Label::InvalidPrintDensityError)
      end
    end
  end

  describe "#<<" do
    it "adds an item to the list of label elements" do
      expect {
        label << stub
      }.to change { label.elements.count }.by 1
    end
  end

  describe "#dump_contents" do
    let(:io) { "" }

    it "dumps its contents to the received IO" do
      label << stub(:to_s => "foobar")
      label << stub(:to_s => "blabla")
      label.width          = 100
      label.length_and_gap = [200, 24]
      label.print_speed    = 3
      label.print_density  = 10
      label.dump_contents(io)
      io.should == "O\nQ200,24\nq100\nS3\nD10\n\nN\nfoobar\nblabla\nP0\n"
    end

    it "does not try to set the label width when it's not informed (falls back to autosense)" do
      label.dump_contents(io)
      io.should_not =~ /q/
    end

    it "does not try to set the length/gap when they were not informed (falls back to autosense)" do
      label.dump_contents(io)
      io.should_not =~ /Q/
    end

    it "does not try to set the print density when it's not informed (falls back to the default value)" do
      label.dump_contents(io)
      io.should_not =~ /D/
    end

    it "raises an error if the print speed was not informed" do
      label = described_class.new
      expect {
        label.dump_contents(io)
      }.to raise_error(Zebra::Epl::Label::PrintSpeedNotInformedError)
    end
  end
end
