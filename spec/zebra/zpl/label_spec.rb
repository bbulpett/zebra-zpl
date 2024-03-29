# encoding: utf-8

require 'spec_helper'

describe Zebra::Zpl::Label do
  subject(:label) { described_class.new print_speed: 2 }

  describe "#new" do
    it "sets default values" do
      expect(described_class.new).to have_attributes({ label_shift: 10, copies: 1 })
    end

    it "sets attributes" do
      attributes = { width: 300, length: 400, print_speed: 2, copies: 4, label_shift: 15 }
      expect(described_class.new(attributes)).to have_attributes(attributes)
    end

    it "validates the printing speed" do
      [-1, 15, "a"].each do |s|
        expect {
          described_class.new print_speed: s
        }.to raise_error(Zebra::Zpl::Label::InvalidPrintSpeedError)
      end
    end
  end

  describe "#<<" do
    it "adds an item to the list of label elements" do
      expect {
        obj = {}
        allow(obj).to receive(:to_zpl) { 'foobar' }
        label << obj
      }.to change { label.elements.count }.by 1
    end
  end

  describe "#dump_contents" do
    let(:io) { "" }

    it "dumps its contents to the received IO" do
      obj1, obj2 = {}, {}
      allow(obj1).to receive(:to_zpl) { 'foobar' }
      allow(obj2).to receive(:to_zpl) { 'blabla' }
      label << obj1
      label << obj2
      label.width          = 100
      label.length         = 200
      label.print_speed    = 3
      label.dump_contents(io)
      expect(io).to eq '^XA^LL200^LH0,0^LS10^PW100^PR3foobarblabla^PQ1^XZ'
    end

    it "does not try to set the label width when it's not informed (falls back to autosense)" do
      label.dump_contents(io)
      expect(io).to_not match /^LL/
    end

    it "does not try to set the length when it is not informed (falls back to autosense)" do
      label.dump_contents(io)
      expect(io).to_not match /^PW/
    end

    it "raises an error if the print speed was not informed" do
      label = described_class.new
      expect {
        label.dump_contents(io)
      }.to raise_error(Zebra::Zpl::Label::PrintSpeedNotInformedError)
    end
  end

  describe "#persist" do

    let(:tempfile) { StringIO.new }
    let(:label) { described_class.new print_speed: 2 }

    before do
      allow(Tempfile).to receive(:new) { tempfile }
      obj = {}
      allow(obj).to receive(:to_zpl) { 'foobar' }
      label << obj
    end

    it "creates a tempfile" do
      expect(Tempfile).to receive(:new).with('zebra_label').and_return(tempfile)
      label.persist
    end

    it "returns the tempfile" do
      expect(label.persist).to eq tempfile
    end

    it "sets the `tempfile` attribute" do
      label.persist
      expect(label.tempfile).to eq tempfile
    end
  end

  describe "#persisted?" do
    it "returns false if the `tempfile` attribute is nil" do
      label = described_class.new print_speed: 2
      expect(label).to_not be_persisted
    end

    it "returns true if the `tempfile` attribute is not nil" do
      label = described_class.new print_speed: 2
      label.instance_variable_set(:@tempfile, Tempfile.new('zebra_label'))
      expect(label).to be_persisted
    end
  end
end
