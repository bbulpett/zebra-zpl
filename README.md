#### This is a gem based on a terrific older gem by Cassio Marques. Although the new printers are mostly compatible with old Eltron (Epl) code, my needs require many of the new Zebra (ZPL) functions.

# Zebra::Zpl

### ToDo: Update documentation with instructions for new features such as font sizing, margins, and text alignment

Zebra::Zpl offers a Ruby DSL to design and print labels using the ZPL programming language.

## Installation

Add this line to your application's Gemfile:

    gem 'zebra-zpl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install zebra-zpl

## Usage

### Building labels

You create new labels with an instance of the `Zebra::Zpl::Label` class. It accepts the following options:

* `copies`: The number of copies to print. This option defaults to 1.
* `width`: The label's width, in dots.
* `length`: The label's length, is dots.
* `gap`: The gap between labels, in dots.
* `print_speed`: The print speed to be used. You can use values between 0 and 6. This option is required.
* `print_density`: The print density to be used. You can use values between 0 and 15. This option is required.

With a label, you can start adding elements to it:

	label = Zebra::Zpl::Label.new :print_density => 8, :print_speed => 3
	text  = Zebra::Zpl::Text.new :data => "Hello, printer!", :position => [100, 100], :font_size => Zebra::Zpl::FontSize::SIZE_2
	label << text

You can add as many elements as you want.

### Printing the labels

You need to have your printer visible to CUPS. Once your printer is configured and you know its name on CUPS, you can send the labels to the printer using a `Zebra::PrintJob` instance.

	label = Zebra::Zpl::Label.new(
	  :width         => 200,
	  :length        => 200,
	  :print_speed   => 3,
	  :print_density => 6
	)


	barcode = Zebra::Zpl::Barcode.new(
	  :data                      => "12345678",
	  :position                  => [50, 50],
	  :height                    => 50,
	  :print_human_readable_code => true,
	  :narrow_bar_width          => 4,
	  :wide_bar_width            => 8,
	  :type                      => Zebra::Zpl::BarcodeType::CODE_128_AUTO
	)

	label << barcode

	print_job = Zebra::PrintJob.new "your-printer-name-on-cups"

	print_job.print label

This will persist the label contents to a tempfile (using Ruby's tempfile core library) and copy the file to the printer using either `lpr -P <your-printer-name-on-cups> -o raw <path-to-the-temp-file>` (if you're on Mac OSX) or `lp -d <your-printer-name-on-cups> -o raw <path-to-the-tempfile>` (if you're on Linux). All the tempfile creation/path resolution, as well as which command has to be used, are handled by the `PrintJob` class.

### Printing to directly to Windows LPD
This gem also supports printing directly to shared printer on Windows using LPD.
In order to print directly to a LPD on a Windows machine you need two things:
- [rlpr](http://manpages.ubuntu.com/manpages/xenial/man1/rlpr.1.html) installed on the (UNIX) system running your app that uses this gem.
- LPD Print Service and LPR Port Monitor features enabled on the Windows machine

<img src="http://i.imgur.com/3CWkEWU.png" style="height: 300px;"/>

### Printing QR codes

    label = Zebra::Zpl::Label.new(
      :width=>350,
      :length=>250,
      :print_speed=>3,
      :print_density=>6
    )

    qrcode = Zebra::Zpl::Qrcode.new(
      :data=>"www.github.com",
      :position=>[50,10],
      :scale_factor=>3,
      :correction_level=>"H"
    )

    label << qrcode

    print_job = Zebra::PrintJob.new "your-qr-printer-name-on-cups"

    print_job.print label

### Available elements

#### Text

You create text elements to print using instances of the `Zebra::Zpl::Text` class. It accepts the following options:

* `position`: An array with the coordinates to place the text, in dots.
* `rotation`: The rotation for the text. More about the possible values below.
* `data`: The text to be printed.
* `v_multiplier`: The vertical multiplier to use.
* `h_multiplier`: The horizontal multipler to use.
* `print_mode`: The print mode. Can be normal ("N") or reverse ("R").
* `font_size`: The font size to use. You can use values between 1 and 5.

For the print modes, you can also use the constants:

* `Zebra::Zpl::PrintMode::NORMAL`
* `Zebra::Zpl::PrintMode::REVERSE`


#### Barcodes

You create barcode elements to print using instances of the `Zebra::Zpl::Barcode` class. It accepts the following options:

* `position`: An array with the coordinates to place the text, in dots.
* `height`: The barcode's height, in dots.
* `rotation`: The rotation for the text. More about the possible values below.
* `data`: The text to be printed.
* `type`: The type os barcode to use. More on the available types below.
* `narrow_bar_width`: The barcode's narrow bar width, in dots.
* `wide_bar_width`: The barcode's wide bar width, in dots.
* `print_human_readable_code`: Can be `true` or `false`, indicates if the human readable contents should be printed below the barcode.

The available barcode types are:

* `Zebra::Zpl::BarcodeType::CODE_39`
* `Zebra::Zpl::BarcodeType::CODE_93`
* `Zebra::Zpl::BarcodeType::CODE_128_AUTO`
* `Zebra::Zpl::BarcodeType::CODABAR`
* `Zebra::Zpl::BarcodeType::CODE_AZTEC`
* `Zebra::Zpl::BarcodeType::CODE_AZTEC_PARAMS`
* `Zebra::Zpl::BarcodeType::CODE_UPS_MAXICODE`
* `Zebra::Zpl::BarcodeType::CODE_QR`

#### QR Codes

You can create QR Codes elements to print using instances of the `Zebra::Zpl::Qrcode` class. It accepts the following options:

* `position`: An array with the coordinates to place the QR code, in dots.
* `scale factor`: Crucial variable of the QR codes's size. Accepted values: 1-99.
* `error correction level`: Algorithm enables reading damaged QR codes. There are four error correction levels: L - 7% of codewords can be restored, M - 15% can be restored, Q - 25% can be restored, H - 30% can be restored.

#### Boxes

You can draw boxes in your labels:

	box = Zebra::Zpl::Box.new :position => [20, 20], :end_position => [100, 100], :line_thickness => 39

#### Elements Rotation

All printable elements can be rotated on the label, using the `:Rotation` option. The accepted rotation values are:

* `Zebra::Zpl::Rotation::NO_ROTATION`: will not rotate the element.
* `Zebra::Zpl::Rotation::DEGREES_90`: will rotate the element 90 degrees.
* `Zebra::Zpl::Rotation::DEGREES_180`: will rotate the element 180 degrees.
* `Zebra::Zpl::Rotation::DEGREES_270`: will rotate the element 270 degrees.

#### Elements Justification

There are four ZPL-supported `:Justification` parameters. "LEFT" (left-justified) is the default.

* `Zebra::Zpl::Justification::LEFT` ~ left-justified
* `Zebra::Zpl::Justification::RIGHT` ~ right-justified
* `Zebra::Zpl::Justification::CENTER` ~ centered
* `Zebra::Zpl::Justification::JUSTIFIED` ~ full-width-justifed _(YMMV)_



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
