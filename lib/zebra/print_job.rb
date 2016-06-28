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

    def print(label, ip)
      @remote_ip = ip
      tempfile = label.persist
      send_to_printer tempfile.path
    end

    private

    def check_existent_printers(printer)
      existent_printers = Cups.show_destinations
      raise UnknownPrinter.new(printer) unless existent_printers.include?(printer)
    end

    def send_to_printer(path)
      puts "* * * * * * * * * * * * Sending file to printer #{@printer} at #{@remote_ip} * * * * * * * * * * "
      # `lp -h #{@remote_ip} -d #{@printer} -o raw #{path}`
      `lp -h #{@remote_ip} -d #{@printer} -o raw ../zpl_test.zpl`
    end
  end
end
