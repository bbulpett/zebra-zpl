# encoding: utf-8
module Zebra
  module Epl
    class Label
      class InvalidPrintSpeedError     < StandardError; end
      class InvalidPrintDensityError   < StandardError; end
      class PrintSpeedNotInformedError < StandardError; end

      attr_reader :elements
      attr_accessor :width, :length, :gap, :print_speed, :print_density

      def initialize(options = {})
        options.each_pair { |key, value| self.__send__("#{key}=", value) if self.respond_to?("#{key}=") }
        @elements = []
      end

      def length_and_gap=(length_and_gap)
        self.length = length_and_gap[0]
        self.gap    = length_and_gap[1]
      end

      def print_speed=(s)
        raise InvalidPrintSpeedError unless (0..6).include?(s)
        @print_speed = s
      end

      def print_density=(d)
        raise InvalidPrintDensityError unless (0..15).include?(d)
        @print_density = d
      end

      def <<(element)
        elements << element
      end

      def dump_contents(io = STDOUT)
        check_required_configurations
        # Start options
        io << "O\n"
        # Q<label height in dots>,<space between labels in dots>
        io << "Q#{length},#{gap}\n" if length && gap
        # q<label width in dots>
        io << "q#{width}\n" if width
        # Print Speed (S command)
        io << "S#{print_speed}\n"
        # Density (D command)
        io << "D#{print_density}\n" if print_density
        # ZT = Printing from top of image buffer.

        io << "\n"
        # Start new label
        io << "N\n"

        elements.each do |element|
          io << element.to_s << "\n"
        end

        io << "P0\n"
      end

      private

      def check_required_configurations
        raise PrintSpeedNotInformedError unless print_speed
      end
    end
  end
end
