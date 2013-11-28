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
      tempfile = label.persist

      begin
        send_to_printer tempfile.path
      ensure
        tempfile.close
        tempfile.unlink
      end
    end

    private

    def check_existent_printers(printer)
      existent_printers = Cups.show_destinations
      raise UnknownPrinter.new(printer) unless existent_printers.include?(printer)
    end

    def send_to_printer(path)
      if RUBY_PLATFORM =~ /darwin/
        `lpr -P #{@printer} -o raw #{path}`
      else
        `lp -d #{@printer} -o raw #{path}`
      end
    end
  end
end
