# encoding: utf-8
module Zebra
  module Epl
    class Label
      attr_reader :elements

      def initialize
        @elements = []
      end

      def <<(element)
        elements << element
      end

      def dump_contents(io = STDOUT)
        # Start options
        io << "O\n"
        # Q<label height in dots>,<space between labels in dots>
        io << "Q240,24\n"
        # q<label width in dots>
        io << "q432\n"
        # Print Speed (S command)
        io << "S2\n"
        # Density (D command)
        io << "D5\n"
        # ZT = Printing from top of image buffer.
        io << "ZT\n"

        io << "\n"
        # Start new label
        io << "N\n"

        elements.each do |element|
          io << element.to_s << "\n"
        end

        io << "P0\n"
      end
    end
  end
end
