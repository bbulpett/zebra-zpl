require 'spec_helper'

describe Zebra::Zpl::Comment do
  it "can be initialized with the data" do
    comment = described_class.new data: "THIS IS A COMMENT"
    expect(comment.data).to eq "THIS IS A COMMENT"
  end

  describe "#to_zpl" do
    subject(:comment) { described_class.new attributes }
    let(:attributes) {{
      data:  "THIS IS A COMMENT",
    }}
    it "contains the comment" do
        expect(comment.to_zpl).to eq "^FXTHIS IS A COMMENT^FS"
    end
  end
end