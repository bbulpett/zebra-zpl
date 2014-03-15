# Zebra::Epl

Zebra::Epl offers a Ruby DSL to design and print labels using the EPL programming language. 

## Installation

Add this line to your application's Gemfile:

    gem 'zebra-epl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zebra-epl

## Usage

### Building labels

You create new labels with an instance of the `Zebra::Epl::Label` class. It accepts the following options:

* `copies`: The number of copies to print. This option defaults to 1.
* `width`: The label's width, in dots.
* `length`: The label's length, is dots.
* `gap`: The gap between labels, in dots.
* `print_speed`: The print speed to be used. You can use values between 0 and 6. This option is required.
* `print_density`: The print density to be used. You can use values between 0 and 15. This option is required.

With a label, you can start adding elements to it:

	label = Zebra::Epl::Label.new :print_density => 8, :print_speed => 3
	text  = Zebra::Epl::Text.new :data => "Hello, printer!", :position => [100, 100], :font => Zebra::Epl::Font::SIZE_2
	label << text
	
You can add as many elements as you want.

### Printing the labels

You need to have your printer visible to CUPS. Once your printer is configured and you know its name on CUPS, you can send the labels to the printer using a `Zebra::PrintJob` instance.

	label = Zebra::Epl::Label.new(
	  :width         => 200,
	  :length        => 200,
	  :print_speed   => 3,
	  :print_density => 6
	)
	
	
	barcode = Zebra::Epl::Barcode.new(
	  :data                      => "12345678",
	  :position                  => [50, 50],
	  :height                    => 50,
	  :print_human_readable_code => true,
	  :narrow_bar_width          => 4,
	  :wide_bar_width            => 8,
	  :type                      => Zebra::Epl::BarcodeType::CODE_128_AUTO
	)
	
	print_job = Zebra::PrintJob.new "your-printer-name-on-cups"
	
	print_job.print label

This will persist the label contents to a tempfile (using Ruby's tempfile core library) and copy the file to the printer using either `lpr -P <your-printer-name-on-cups> -o raw <path-to-the-temp-file>` (if you're on Mac OSX) or `lp -d <your-printer-name-on-cups> -o raw <path-to-the-tempfile>` (if you're on Linux). All the tempfile creation/path resolution, as well as which command has to be used, are handled by the `PrintJob` class. 


	
### Available elements

#### Text

You create text elements to print using instances of the `Zebra::Epl::Text` class. It accepts the following options:

* `position`: An array with the coordinates to place the text, in dots. 
* `rotation`: The rotation for the text. More about the possible values below.
* `data`: The text to be printed.
* `v_multiplier`: The vertical multiplier to use. 
* `h_multiplier`: The horizontal multipler to use.
* `print_mode`: The print mode. Can be normal ("N") or reverse ("R").
* `font`: The font size to use. You can use values between 1 and 5.

For the print modes, you can also use the constants:

* `Zebra::Epl::PrintMode::NORMAL`
* `Zebra::Epl::PrintMode::REVERSE`


#### Barcodes

You create barcode elements to print using instances of the `Zebra::Epl::Barcode` class. It accepts the following options:

* `position`: An array with the coordinates to place the text, in dots. 
* `height`: The barcode's height, in dots.
* `rotation`: The rotation for the text. More about the possible values below.
* `data`: The text to be printed.
* `type`: The type os barcode to use. More on the available types below.
* `narrow_bar_width`: The barcode's narrow bar width, in dots.
* `wide_bar_width`: The barcode's wide bar width, in dots.
* `print_human_readable_code`: Can be `true` or `false`, indicates if the human readable contents should be printed below the barcode.

The available barcode types are:

* `Zebra::Epl::BarcodeType::CODE_39`
* `Zebra::Epl::BarcodeType::CODE_39_CHECK_DIGIT`
* `Zebra::Epl::BarcodeType::CODE_93`
* `Zebra::Epl::BarcodeType::CODE_128_AUTO`
* `Zebra::Epl::BarcodeType::CODE_128_A`
* `Zebra::Epl::BarcodeType::CODE_128_B`
* `Zebra::Epl::BarcodeType::CODE_128_C`
* `Zebra::Epl::BarcodeType::CODABAR`

#### Boxes

You can draw boxes in your labels:

	box = Zebra::Epl::Box.new :position => [20, 20], :end_position => [100, 100], :line_thickness => 39
	
#### Elements rotation

All printable elements can be rotated on the label, using the `:rotation` option. The accepted rotation values are:

* `Zebra::Epl::Rotation::NO_ROTATION`: will not rotate the element.
* `Zebra::Epl::Rotation::DEGREES_90`: will rotate the element 90 degrees.
* `Zebra::Epl::Rotation::DEGREES_180`: will rotate the element 180 degrees.
* `Zebra::Epl::Rotation::DEGREES_270`: will rotate the element 270 degrees.



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
