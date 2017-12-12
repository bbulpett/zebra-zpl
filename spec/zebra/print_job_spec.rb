require 'spec_helper'

describe Zebra::PrintJob do
  it "receives the name of a printer" do
    expect(described_class.new("Zebra").printer).to eq("Zebra")
  end

  describe "#print" do
    let(:label) { double :persist => tempfile }
    let(:ip) { "0.0.0.0"}
    let(:cups_job) { double :print => true }
    let(:tempfile) { double(:path => "/foo/bar").as_null_object }

    subject(:print_job) { described_class.new "Zebra" }

    before { allow(print_job).to receive_messages(:` => true) }

    it "creates a cups print job with the correct arguments" do
      expect(print_job).to receive("send_to_printer")
      print_job.print label, ip
    end

    it "prints the label" do
      expect(print_job).to receive("send_to_printer").with("/foo/bar")
      print_job.print label, ip
    end
  end
end
