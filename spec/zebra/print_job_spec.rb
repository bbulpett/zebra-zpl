require 'spec_helper'

describe Zebra::PrintJob do
  before do
    Cups.stub(:show_destinations).and_return(["Zebra", "Foobar"])
  end

  it "receives the name of a printer" do
    described_class.new("Zebra").printer.should == "Zebra"
  end

  it "raises an error if the printer does not exists" do
    expect {
      described_class.new("Wrong")
    }.to raise_error(Zebra::PrintJob::UnknownPrinter)
  end

  describe "#print" do
    let(:label) { stub :path => "/foo/bar" }
    let(:cups_job) { stub :print => true }

    subject(:print_job) { described_class.new "Zebra" }

    before { Cups::PrintJob.stub(:new).and_return(cups_job) }

    it "creates a cups print job with the correct arguments" do
      Cups::PrintJob.should_receive(:new).with("/foo/bar", "Zebra").and_return(cups_job)
      print_job.print label
    end

    it "prints the label" do
      cups_job.should_receive(:print)
      print_job.print label
    end
  end
end
