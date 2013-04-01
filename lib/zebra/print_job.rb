module Zebra
  class PrintJob
    class UnknownPrinter < StandardError
      def initialize(printer)
        super("Could not find a printer named #{printer}")
      end
    end

    attr_reader :printer

    def initialize(printer)
      check_existent_printers printer

      @printer = printer
    end

    def print(label)
      Cups::PrintJob.new(label.path, @printer).print
    end

    private

    def check_existent_printers(printer)
      existent_printers = Cups.show_destinations
      raise UnknownPrinter.new(printer) unless existent_printers.include?(printer)
    end
  end
end
