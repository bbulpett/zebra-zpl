# encoding: utf-8

require 'spec_helper'

describe Zebra::Zpl::Label do
  subject(:label) { described_class.new :print_speed => 2 }

  describe "#new" do
    it "sets the label width" do
      label = described_class.new :width => 300
      expect(label.width).to eq 300
    end

    it "sets the label length/gap" do
      label = described_class.new :length_and_gap => [400, 24]
      expect(label.length).to eq 400
      expect(label.gap).to eq 24
    end

    it "sets the printing speed" do
      label = described_class.new :print_speed => 2
      expect(label.print_speed).to eq 2
    end

    it "sets the number of copies" do
      label = described_class.new :copies => 4
      expect(label.copies).to eq 4
    end

    it "the number of copies defaults to 1" do
      label = described_class.new
      expect(label.copies).to eq 1
    end

    it "validates the printing speed" do
      [-2, 16, "a"].each do |s|
        expect {
          described_class.new :print_speed => s
        }.to raise_error(Zebra::Zpl::Label::InvalidPrintSpeedError)
      end
    end

    it "sets the print density" do
      label = described_class.new :print_density => 10
      expect(label.print_density).to eq 10
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
        label << double(width: 2)
      }.to change{ label.elements.count }.by 1
    end
  end

  describe "#dump_contents" do
    let(:io) { "" }

    it "dumps its contents to the received IO" do
      label << Zebra::Zpl::Raw.new(width: 10)
      label << Zebra::Zpl::Raw.new(width: 12)
      label.width          = 100
      label.length_and_gap = [200, 24]
      label.print_speed    = 3
      label.print_density  = 10
      label.dump_contents(io)
      expect(io).to eq "^XA^LL200^LH0,0^LS10^PW100^PR3^FWN^FO,^FS^FWN^FO,^FS^PQ1^XZ"
    end

    it "does not try to set the label width when it's not informed (falls back to autosense)" do
      label.dump_contents(io)
      expect(io).to_not match(/q/)
    end

    it "does not try to set the print density when it's not informed (falls back to the default value)" do
      label.dump_contents(io)
      expect(io).to_not match(/D/)
    end

    it "raises an error if the print speed was not informed" do
      label = described_class.new
      expect {
        label.dump_contents(io)
      }.to raise_error(Zebra::Zpl::Label::PrintSpeedNotInformedError)
    end
  end

  describe "#persist" do
    let(:tempfile) { double.as_null_object }
    let(:label)    { described_class.new :print_speed => 2 }

    before do
      allow(Tempfile).to receive_messages :new => tempfile
      box = double(width: 10)
      allow(box).to receive(:to_zpl)
      label << box
    end

    it "creates a tempfile" do
      expect(Tempfile).to receive(:new).with("zebra_label").and_return(tempfile)
      label.persist
    end

    it "returns the tempfile" do
      expect(label.persist).to eq tempfile
    end

    it "sets the `tempfile` attribute" do
      label.persist
      expect(label.tempfile).to eq  tempfile
    end
  end

  describe "#persisted?" do
    it "returns false if the `tempfile` attribute is nil" do
      label = described_class.new :print_speed => 2
      expect(label).to_not be_persisted
    end

    it "returns true if the `tempfile` attribute is not nil" do
      label = described_class.new :print_speed => 2
      label.instance_variable_set(:@tempfile, "double")
      expect(label).to be_persisted
    end
  end
end
