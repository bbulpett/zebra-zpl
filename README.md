# Zebra::Zpl

[![gem](https://img.shields.io/gem/v/zebra-zpl?color=orange)](https://rubygems.org/gems/zebra-zpl)
[![downloads](https://img.shields.io/gem/dt/zebra-zpl?color=brightgreen)](https://rubygems.org/gems/zebra-zpl)

Zebra::Zpl offers a Ruby DSL to design and print labels using the ZPL programming language.

## Contents

  - [Installation](#installation)
  - [Usage](#usage)
    - [Building Labels](#building-labels)
    - [Printing Labels](#printing-the-labels)
    - [Elements](#available-elements)
      - [Text](#text)
      - [Barcodes](#barcodes)
      - [QR Codes](#qr-codes)
      - [Data Matrix](#data-matrix)      
      - [Boxes](#boxes)
      - [Images](#images)
    - [Options](#options)
      - [Rotation](#elements-rotation)
      - [Justification](#elements-justification)
  - [Contributing](#contributing)
  - [References](#references)


## Installation

Add this line to your application's Gemfile:

    gem 'zebra-zpl'

And then execute:

    bundle install

Or install it yourself as:

    gem install zebra-zpl

## Usage

### Building labels

You create new labels with an instance of the `Zebra::Zpl::Label` class. It accepts the following options:

* `copies`: The number of copies to print. This option defaults to 1.
* `width`: The label's width, in dots.
* `length`: The label's length, is dots.
* `print_speed`: The print speed to be used. You can use values between 0 and 6. This option is required.

With a label, you can start adding elements to it:

```ruby
label = Zebra::Zpl::Label.new print_speed: 3
text  = Zebra::Zpl::Text.new(
  data:       "Hello, printer!",
  position:   [100, 100],
  font_size:  Zebra::Zpl::FontSize::SIZE_2
)
label << text
```

You can add as many elements as you want.

### Printing the labels

You need to have your printer visible to CUPS (or shared on the network in Windows). Once your printer is configured and you know its name on CUPS (or the Windows shared printer name), you can send the labels to the printer using a `Zebra::PrintJob` instance.

```ruby
label = Zebra::Zpl::Label.new(
  width:        200,
  length:       200,
  print_speed:  3
)


barcode = Zebra::Zpl::Barcode.new(
  data:                       '12345678',
  position:                   [50, 50],
  height:                     50,
  print_human_readable_code:  true,
  narrow_bar_width:           4,
  wide_bar_width:             8,
  type:                       Zebra::Zpl::BarcodeType::CODE_128_AUTO
)

label << barcode

print_job = Zebra::PrintJob.new '<your-printer-name-on-cups/windows-shared-printer-name>'

ip = '<IP/Host where the print queue lives>'  # can use 'localhost', '127.0.0.1', or '0.0.0.0' for local machine

print_job.print label, ip
```

This will persist the label contents to a tempfile (using Ruby's tempfile core library) and copy the file to the printer using either `rlpr -H <hostname/ip> -P <your-printer-name-on-windows> -o <path-to-the-temp-file>` (for Windows systems, see [section](#printing-directly-to-windows-lpd) below) or `lp -h <hostname/ip> -d <your-printer-name-on-cups> -o raw <path-to-the-tempfile>` (for Unix systems). All the tempfile creation/path resolution, as well as which command has to be used, are handled by the `PrintJob` class.

#### Printing directly to Windows LPD
This gem also supports printing directly to shared printer on Windows using LPD.
In order to print directly to a LPD on a Windows machine you need two things:
- [rlpr](http://manpages.ubuntu.com/manpages/xenial/man1/rlpr.1.html) installed on the (UNIX) system running your app that uses this gem.<sup>[1](#fn1)</sup>
- LPD Print Service and LPR Port Monitor features enabled on the Windows machine.<sup>[2](#fn2)</sup>

<p align="center">
<img align="center" src="http://i.imgur.com/3CWkEWU.png" height="300px"/>
<p/>

<hr/>

<sup><a name="fn1">1</a>. On a distro such as Ubuntu simply do: `sudo apt-get install rlpr`  
If using OSX then you will have to manually build it from source and add it to your `$PATH` environment variable.<sup/>

<sup><a name="fn2">2</a>. The printer name that you pass in must correspond with the **shared printer name** on the Windows machine.</sup>

### Available elements

#### Text

You create text elements to print using instances of the `Zebra::Zpl::Text` class. It accepts the following options:

* `position`: An array with the coordinates to place the text, in dots.
* `rotation`: The rotation for the text. More about the possible values below.
* `data`: The text to be printed.
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
* `scale_factor`: Crucial variable of the QR codes's size. Accepted values: 1-99.
* `correction_level`: Algorithm enables reading damaged QR codes. There are four error correction levels: L - 7% of codewords can be restored, M - 15% can be restored, Q - 25% can be restored, H - 30% can be restored.

##### Printing QR codes

```ruby
label = Zebra::Zpl::Label.new(
  width:        350,
  length:       250,
  print_speed:  3
)

qrcode = Zebra::Zpl::Qrcode.new(
  data:             'www.github.com',
  position:         [50,10],
  scale_factor:     3,
  correction_level: 'H'
)

label << qrcode

print_job = Zebra::PrintJob.new '<your-qr-printer-name-on-cups>'

print_job.print label, '<hostname>'
```

#### Data Matrix

You can create Data Matrix elements to print using instances of the `Zebra::Zpl::Datamatrix` class. It accepts the following options:

* `position`: An array with the coordinates to place the data matrix, in dots.
* `symbol_height`: Crucial variable of the size size of the data matrix. Accepted values: 1 - label width.
* `aspect_ratio`: 1 for square, 2 for rectangular.

```ruby
datamatrix = Zebra::Zpl::Datamatrix.new(
  data:             'www.github.com',
  position:         [50,50],
  symbol_height:     5
)
```

#### Boxes

You can draw boxes in your labels:

* `position`: An array with the coordinates to place the QR code, in dots.
* `box_width`: The width of the box in dots
* `box_height`: The height of the box in dots
* `color`: The color if the lines. `B` for black, `W` for white.
* `line_thickness`: The thickness of the border in dots
* `rounding_degree`: The degree which to round the corners. (0-8)

```ruby
box = Zebra::Zpl::Box.new(
  position: [20,20],
  box_width: 5,
  box_height: 4,
  color: 'B',
  line_thickness: 3,
  rounding_degree: 6
)
```

#### Images

You can also create graphics elements from an image using the `Zebra::Zpl::Image` class. Images are converted and encoded into an `^GF` (_Graphics Field_) command using the [img2zpl](https://github.com/mtking2/img2zpl) gem. Accepted parameters are:

* `path` (required): The file path or URL of an image.
* `position`: An array with the coordinates to place the image, in dots.
* `width`: The width (in pixels) that the image should be printed.
* `height`: The height (in pixels) that the image should be printed.
* `rotation`: The number of degrees the image should be rotated
  * unlike the other elements with strict 90° rotations, image elements can be rotated any number of degrees since the image is rotated with imagemagick before conversion to ZPL.
* `black_threshold`: A value between 0 and 1 that sets the darkness threshold which determines how dark a pixel should be in order to become black in the resulting b/w image. Use larger value for a more saturated image and smaller value for a less saturated one. Default: `0.5`
* `invert`: set to `true` to invert which pixels are set to black and which are set to white. Default is, depending on the `black_threshold`, dark pixels become black and light pixels become white.

```ruby
image = Zebra::Zpl::Image.new(
  path: '/path/to/my/image.jpg',
  position: [100, 50],
  width: 200,
  height: 180,
  rotation: -90,
  black_threshold: 0.35
)
```

### Options

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

See [CONTRIBUTING.md](CONTRIBUTING.md) on how to contribute to this project.

See [CHANGELOG.md](CHANGELOG.md) for a list of changes by version as well as all the awesome people who have contributed to the project.

## References

###### This is a gem based on a terrific older gem by Cassio Marques. Although the new printers are mostly compatible with old Eltron (Epl) code, our needs require many of the new Zebra (ZPL) functions.
* [Zebra Technologies Corporation, _"ZPL II Programming Guide."_ 2019 PDF](https://www.zebra.com/content/dam/zebra/manuals/printers/common/programming/zpl-zbi2-pm-en.pdf)
