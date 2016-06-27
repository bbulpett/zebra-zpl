# encoding: utf-8

require 'spec_helper'

describe Zebra::Zpl::Label do
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

    it "sets the number of copies" do
      label = described_class.new :copies => 4
      label.copies.should == 4
    end

    it "the number of copies defaults to 1" do
      label = described_class.new
      label.copies.should == 1
    end

    it "validates the printing speed" do
      [-1, 8, "a"].each do |s|
        expect {
          described_class.new :print_speed => s
        }.to raise_error(Zebra::Zpl::Label::InvalidPrintSpeedError)
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
        }.to raise_error(Zebra::Zpl::Label::InvalidPrintDensityError)
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
      label << stub(:to_zpl => "foobar")
      label << stub(:to_zpl => "blabla")
      label.width          = 100
      label.length_and_gap = [200, 24]
      label.print_speed    = 3
      label.print_density  = 10
      label.dump_contents(io)
      io.should == "O\nQ200,24\nq100\nS3\nD10\n\nN\nfoobar\nblabla\nP1\n"
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
      }.to raise_error(Zebra::Zpl::Label::PrintSpeedNotInformedError)
    end
  end

  describe "#persist" do
    let(:tempfile) { stub.as_null_object }
    let(:label)    { described_class.new :print_speed => 2 }

    before do
      Tempfile.stub :new => tempfile
      label << stub(:to_zpl => "foobar")
    end

    it "creates a tempfile" do
      Tempfile.should_receive(:new).with("zebra_label").and_return(tempfile)
      label.persist
    end

    it "returns the tempfile" do
      label.persist.should == tempfile
    end

    it "sets the `tempfile` attribute" do
      label.persist
      label.tempfile.should == tempfile
    end
  end

  describe "#persisted?" do
    it "returns false if the `tempfile` attribute is nil" do
      label = described_class.new :print_speed => 2
      label.should_not be_persisted
    end

    it "returns true if the `tempfile` attribute is not nil" do
      label = described_class.new :print_speed => 2
      label.instance_variable_set(:@tempfile, stub)
      label.should be_persisted
    end
  end
end
