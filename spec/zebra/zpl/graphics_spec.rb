require 'spec_helper'

describe Zebra::Zpl::Graphic do
    it "can be initialized with graphic type" do
      graphic = described_class.new graphic_type: Zebra::Zpl::Graphic::ELIPSE
      expect(graphic.graphic_type).to eq "E"
    end

    it "can be initialized with a graphic width" do
      graphic = described_class.new graphic_width: 30
      expect(graphic.graphic_width).to eq 30
    end

    it "can be initialized with a graphic height" do
        graphic = described_class.new graphic_height: 30
        expect(graphic.graphic_height).to eq 30
    end

    it "can be initialized with a line_thickness" do
        graphic = described_class.new line_thickness: 3
        expect(graphic.line_thickness).to eq 3
    end

    it "can be initialized with a color" do
        graphic = described_class.new color: "W"
        expect(graphic.color).to eq "W"
    end

    it "can be initialized with an orientation" do
        graphic = described_class.new orientation: "R"
        expect(graphic.orientation).to eq "R"
    end

    it "can be initialized with a rounding degree" do
        graphic = described_class.new rounding_degree: 2
        expect(graphic.rounding_degree).to eq 2
    end
    

  
    describe "#orientation" do
      it "raises an error if the orientation not in [N L]" do
        expect { described_class.new orientation: 'A' }.to raise_error(Zebra::Zpl::Graphic::InvalidOrientationError)
      end
    end

    describe "#color" do
      it "raises an error if the color not in [B W]" do
        expect { described_class.new color: 'A' }.to raise_error(Zebra::Zpl::Graphic::InvalidColorError)
      end
    end

    describe "#line_thickness" do
      it "raises an error if line thickness is not a number" do
        expect { described_class.new line_thickness: 'A' }.to raise_error(Zebra::Zpl::Graphic::InvalidLineThickness)
      end
    end

    describe "#graphic_type" do
      it "raises an error if the graphic type not in [E B D C S]" do
        expect { described_class.new graphic_type: 'A' }.to raise_error(Zebra::Zpl::Graphic::InvalidGraphicType)
      end
    end

    describe "#to_zpl" do
      let(:valid_attributes) { {
        position:         [50, 50],
        graphic_type:     Zebra::Zpl::Graphic::ELIPSE
      }}
      let(:graphic_elipse) { described_class.new valid_attributes }
      let(:graphic_diaganol) { described_class.new }
      let(:graphic_box) { described_class.new }
      let(:graphic_symbol) { described_class.new }
      let(:graphic_circle) { described_class.new }
      
      let(:tokens_elipse) { graphic.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_diaganol) { graphic.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_box) { graphic.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_symbol) { graphic.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_circle) { graphic.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

      it "raises an error if the X position is not given" do
        graphic = described_class.new position: [nil, 50], graphic_type: described_class::ELIPSE
        expect {
          graphic.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the X value is not given")
      end

      it "raises an error if the Y position is not given" do
        graphic = described_class.new position: [50, nil], graphic_type: described_class::ELIPSE
        expect {
          graphic.to_zpl
        }.to raise_error(Zebra::Zpl::Printable::MissingAttributeError, "Can't print if the Y value is not given")
      end

     
    end

        
=begin
   

      it "contains the barcode command '^B'" do
        expect(datamatrix.to_zpl).to match /\^B/
      end

      it "contains the X position" do
        expect(tokens[2]).to eq "50"
      end

      it "contains the Y position" do
        expect(tokens[3]).to eq "50"
      end

      it "contains Data Matrix code type" do
        expect(tokens[4]).to eq "^BXN"
      end

      it "contains the symbol_height" do
        expect(tokens[5]).to eq "5"
      end

      it "contains the quality level" do
        expect(tokens[6]).to eq "200"
      end

      it "contains the data to be printed in the datamatrix" do
        expect(tokens[8]).to eq "foobar"
      end

  end
=end
end
