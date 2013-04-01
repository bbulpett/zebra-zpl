# encoding: utf-8

require 'spec_helper'

describe Zebra::Epl::Label do
  subject(:label) { described_class.new }

  describe "#<<" do
    it "adds an item to the list of label elements" do
      expect {
        label << stub
      }.to change { label.elements.count }.by 1
    end

    describe "#dump_contents" do
      let(:io) { "" }

      it "dumps its contents to the received IO" do
        label << stub(:to_s => "foobar")
        label << stub(:to_s => "blabla")
        label.dump_contents(io)
        io.should == "O\nQ240,24\nq432\nS2\nD5\nZT\n\nN\nfoobar\nblabla\nP0\n"
      end
    end
  end
end
