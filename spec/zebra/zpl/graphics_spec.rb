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
        graphic_width:     200,
        graphic_height:    300,
        line_thickness:    2,
        color:             "B",
        orientation:       "L"
      }}
      let(:graphic_elipse) { described_class.new valid_attributes.merge({graphic_type: Zebra::Zpl::Graphic::ELIPSE}) }
      let(:graphic_diagonal) { described_class.new valid_attributes.merge({graphic_type: Zebra::Zpl::Graphic::DIAGONAL})}
      let(:graphic_box) { described_class.new valid_attributes.merge({graphic_type: Zebra::Zpl::Graphic::BOX}) }
      let(:graphic_symbol) { described_class.new valid_attributes.merge({graphic_type: Zebra::Zpl::Graphic::SYMBOL}) }
      let(:graphic_circle) { described_class.new valid_attributes.merge({graphic_type: Zebra::Zpl::Graphic::CIRCLE}) }
      
      let(:tokens_elipse) { graphic_elipse.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_diagonal) { graphic_diagonal.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_box) { graphic_box.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_symbol) { graphic_symbol.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }
      let(:tokens_circle) { graphic_circle.to_zpl.split(/(\^[A-Z]+|\,)/).reject{ |e| ['', ',', nil].include?(e) } }

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

      it "raises an error if Graphic Type is not given" do
        graphic = described_class.new position: [50, 50]
        expect {
          graphic.to_zpl
        }.to raise_error(Zebra::Zpl::Graphic::InvalidGraphicType)
      end

      it "contains the X position" do
        expect(tokens_elipse[2]).to eq "50"
      end

      it "contains the Y position" do
        expect(tokens_elipse[1]).to eq "50"
      end

      #Elipse Attributes
      
      it "elipse contains the elipse graphic command '^GE'" do
        expect(tokens_elipse[3]).to eq "^GE"
      end

      it "elipse contains the graphic width" do
        expect(tokens_elipse[4]).to eq "200"
      end

      it "elipse contains the graphic height" do
        expect(tokens_elipse[5]).to eq "300"
      end

      it "elipse contains the line thickness" do
        expect(tokens_elipse[6]).to eq "2"
      end

      it "elipse contains the color" do
        expect(tokens_elipse[7]).to eq "B"
      end

      #Box Attributes

      it "box contains the box graphic command '^GB'" do
        expect(tokens_box[3]).to eq "^GB"
      end

      it "box contains the graphic width" do
        expect(tokens_box[4]).to eq "200"
      end

      it "box contains the graphic height" do
        expect(tokens_box[5]).to eq "300"
      end

      it "box contains the line thickness" do
        expect(tokens_box[6]).to eq "2"
      end

      it "box contains the color" do
        expect(tokens_box[7]).to eq "B"
      end

      it "box contains the orientation" do
        expect(tokens_box[8]).to eq "L"
      end

      #Circle Attributes

      it "circle contains the circle graphic command '^GC'" do
        expect(tokens_circle[3]).to eq "^GC"
      end

      it "circle contains the graphic width" do
        expect(tokens_circle[4]).to eq "200"
      end

      it "circle contains the line thickness" do
        expect(tokens_circle[5]).to eq "2"
      end

      it "circle contains the color" do
        expect(tokens_circle[6]).to eq "B"
      end

      #Diagonal Attributes

      it "diagonal contains the diagonal graphic command '^GD'" do
        expect(tokens_diagonal[3]).to eq "^GD"
      end

      it "diagonal contains the graphic width" do
        expect(tokens_diagonal[4]).to eq "200"
      end

      it "diagonal contains the graphic width" do
        expect(tokens_diagonal[5]).to eq "300"
      end

      it "diagonal contains the line thickness" do
        expect(tokens_diagonal[6]).to eq "2"
      end

      it "diagonal contains the color" do
        expect(tokens_diagonal[7]).to eq "B"
      end

      it "diagonal contains the orientation" do
        expect(tokens_diagonal[8]).to eq "L"
      end
     
    #Symbol Attributes

      it "symbol contains the symbol graphic command '^GS'" do
        puts tokens_symbol
        expect(tokens_symbol[3][0..2]).to eq "^GS"
       
      end

      it "symbol contains the orientation" do
        expect(tokens_symbol[3][3]).to eq "L"
      end

      it "symbol contains the graphic height" do
        expect(tokens_symbol[4]).to eq "300"
      end

      it "symbol contains the graphic width" do
        expect(tokens_symbol[5]).to eq "200"
      end      
    end
end
