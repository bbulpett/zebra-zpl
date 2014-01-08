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
    let(:label) { stub :persist => tempfile }
    let(:cups_job) { stub :print => true }
    let(:tempfile) { stub(:path => "/foo/bar").as_null_object }

    subject(:print_job) { described_class.new "Zebra" }

    before { print_job.stub(:` => true) }

    it "creates a cups print job with the correct arguments" do
      print_job.print label
    end

    it "prints the label" do
      print_job.should_receive(:`).with("lpr -P Zebra -o raw /foo/bar")
      print_job.print label
    end
  end
end
