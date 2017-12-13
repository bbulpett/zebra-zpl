module Zebra
  class PrintJob
    attr_reader :printer

    def initialize(printer)
      @printer = printer
    end

    def print(label, ip)
      @remote_ip = ip
      tempfile = label.persist
      send_to_printer tempfile.path
    end

    private

    def send_to_printer(path)
      puts "* * * * * * * * * * * * Sending file to printer #{@printer} at #{@remote_ip} * * * * * * * * * * "
      result = system("rlpr -H #{@remote_ip} -P #{@printer} -o raw #{path} 2>&1") # try printing to LPD on windows machine first
      system("lp -h #{@remote_ip} -d #{@printer} -o raw #{path}") if !result # print to unix (CUPS) if rlpr failed
    end
  end
end
