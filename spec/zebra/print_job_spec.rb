require 'spec_helper'

describe Zebra::PrintJob do
  it "receives the name of a printer" do
    expect(described_class.new("Zebra").printer).to eq 'Zebra'
  end

  describe "#print" do
    let(:label) { Zebra::Zpl::Label.new(print_speed: 2) }
    let(:ip) { '127.0.0.1' }

    subject(:print_job) { described_class.new "Zebra" }

    before { print_job.stub(:` => true) }

    it "creates a cups print job with the correct arguments" do
      print_job.print label, ip
    end

    it "prints the label" do
      expect(print_job).to receive(:system).with(/r?lpr? -(h|H) 127.0.0.1 -(d|P) Zebra.*/).at_least(:once)
      print_job.print label, ip
    end
  end
end
