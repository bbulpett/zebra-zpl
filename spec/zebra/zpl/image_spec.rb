require 'spec_helper'

describe Zebra::Zpl::Image do

  it 'can be initialized with a path' do
    img = described_class.new path: 'spec/fixtures/default.jpg'
    expect(img.path).to match /^(.+)\/([^\/]+)$/
  end

  it 'can be initialized with dimensions (width & height)' do
    img = described_class.new width: 800, height: 600
    expect(img.width).to eq 800
    expect(img.height).to eq 600
  end

  it 'can be initialized with a rotation amount' do
    img = described_class.new rotation: 90
    expect(img.rotation).to eq 90
  end

  it 'can be initialized with a black threshold' do
    img = described_class.new black_threshold: 0.25
    expect(img.black_threshold).to eq 0.25
  end

  it 'can be initialized with the invert flag' do
    img = described_class.new invert: true
    expect(img.invert).to eq true
  end

  it 'can be initialized with the compress flag' do
    img = described_class.new compress: true
    expect(img.compress).to eq true
  end

  describe '#width' do
    it 'raises an error if an invalid width is given' do
      expect { described_class.new width: -10 }.to raise_error(Zebra::Zpl::Image::InvalidSizeError)
      expect { described_class.new width: 'abc' }.to raise_error(Zebra::Zpl::Image::InvalidSizeError)
    end
  end

  describe '#height' do
    it 'raises an error if an invalid height is given' do
      expect { described_class.new height: -10 }.to raise_error(Zebra::Zpl::Image::InvalidSizeError)
      expect { described_class.new height: 'abc' }.to raise_error(Zebra::Zpl::Image::InvalidSizeError)
    end
  end

  describe '#rotation' do
    it 'raises an error if an invalid rotation value is given' do
      expect { described_class.new rotation: '90d' }.to raise_error(Zebra::Zpl::Image::InvalidRotationError)
      expect { described_class.new rotation: 'abc' }.to raise_error(Zebra::Zpl::Image::InvalidRotationError)
    end
  end

  describe '#black_threshold' do
    it 'raises an error if an invalid black threshold is given' do
      expect { described_class.new black_threshold: -5 }.to raise_error(Zebra::Zpl::Image::InvalidThresholdError)
      expect { described_class.new black_threshold: 1.1 }.to raise_error(Zebra::Zpl::Image::InvalidThresholdError)
    end
  end

  describe '#to_zpl' do
    let(:valid_attributes) { {
      path:       'spec/fixtures/default.jpg',
      position:   [50, 50],
      width:      100,
      height:     150
    }}
    let(:image) { described_class.new valid_attributes }
    let(:tokens) { image.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

    it 'raises an error if the X position is not given' do
      qrcode = described_class.new position: [nil, 50]
      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
    end

    it 'raises an error if the Y position is not given' do
      qrcode = described_class.new position: [50, nil]
      expect {
        qrcode.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
    end

    it 'raises an error if the path is not given' do
      valid_attributes.delete :path

      expect {
        image.to_zpl
      }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the path is invalid or not given")
    end

    it "contains the Graphics Field command '^GF'" do
      expect(image.to_zpl).to match /\^GF/
    end

    it 'contains the X position' do
      expect(tokens[1]).to eq '50'
    end

    it 'contains the Y position' do
      expect(tokens[2]).to eq '50'
    end

    it 'contains the properly encoded image' do
      expect(tokens[3..-1].join).to eq '^GFA1079107913:::::M0FR06L0IFQ07K03IFEP0FK07JFO01F8J01KF8N01F8J03KFCN03FCJ07KFEN03FCJ07LFN07FEJ0MF8M07HFJ0MF8M0IFI01MF8L01IF8I01MFCL01IF8I01MFCL03IFCI03MFCL03IFCI03MFCL07IFEI03MFEL0KF:I03MFEK01KF8:I03MFCK03KFCI01MFCK03KFEI01MFCK07KFEI01MFCK0MFJ0MF8K0MFJ0MF8J01MF8J07LFK01MF8J07KFEK03MFCJ03KFCK03MFEJ01KF8K07MFEK0KFL0OFK03IFEL08M01L0IF8L01F8::::::P03MFC:::::::::::::::::::::::::::::::::::^FS'
    end

  end
end
