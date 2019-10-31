# encoding: utf-8

module Zebra
  module Zpl
    class Label
      class InvalidPrintSpeedError     < StandardError; end
      class InvalidPrintDensityError   < StandardError; end
      class PrintSpeedNotInformedError < StandardError; end

      attr_writer :copies
      attr_reader :elements, :tempfile
      attr_accessor :width, :length, :print_speed

      def initialize(options = {})
        options.each_pair { |key, value| self.__send__("#{key}=", value) if self.respond_to?("#{key}=") }
        @elements = []
      end

      def print_speed=(s)
        raise InvalidPrintSpeedError unless (0..6).include?(s)
        @print_speed = s
      end

      def copies
        @copies || 1
      end

      def <<(element)
        element.width = self.width if element.respond_to?("width=") && element.width.nil?
        elements << element
      end

      def dump_contents(io = STDOUT)
        check_required_configurations
        # Start format
        io << "^XA"
        # ^LL<label height in dots>,<space between labels in dots>
        # io << "^LL#{length},#{gap}\n" if length && gap
        io << "^LL#{length}" if length
        # ^LH<label home - x,y coordinates of top left label>
        io << "^LH0,0"
        # ^LS<shift the label to the left(or right)>
        io << "^LS10"
        # ^PW<label width in dots>
        io << "^PW#{width}" if width
        # Print Rate(speed) (^PR command)
        io << "^PR#{print_speed}"
        # Density (D command) "Carried over from EPL, does this exist in ZPL ????"
        # io << "D#{print_density}\n" if print_density

        # TEST ZPL (comment everything else out)...
        # io << "^XA^WD*:*.FNT*^XZ"
        # TEST ZPL SEGMENT
        # io << "^WD*:*.FNT*"
        # TEST AND GET CONFIGS
        # io << "^HH"

        elements.each do |element|
          io << element.to_zpl
        end
        # Specify how many copies to print
        io << "^PQ#{copies}"
        # End format
        io << "^XZ"
      end

      def persist
        tempfile = Tempfile.new "zebra_label"
        dump_contents tempfile
        tempfile.close
        @tempfile = tempfile
        tempfile
      end

      def persisted?
        !!self.tempfile
      end

      private

      def check_required_configurations
        raise PrintSpeedNotInformedError unless print_speed
      end
    end
  end
end
