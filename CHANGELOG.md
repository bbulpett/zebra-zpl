### 1.1.3 (next)

* Your contribution here.

### 1.1.2 (02/25/2019)

* [#63](https://github.com/bbulpett/zebra-zpl/pull/63): Un-restrict font size - [@mtking2](https://github.com/mtking2)
* [#62](https://github.com/bbulpett/zebra-zpl/pull/62): Add print service option for print jobs (`lp`/`rlpr`) - [@LagTag](https://github.com/LagTag)

### 1.1.1 (12/19/2019)

* [#58](https://github.com/bbulpett/zebra-zpl/pull/58): Add access to source `Img2Zpl::Image` object - [@mtking2](https://github.com/mtking2)

### 1.1.0 (11/04/2019)

* [#54](https://github.com/bbulpett/zebra-zpl/pull/54): Fix height bug with ^B commands - [@mtking2](https://github.com/mtking2)
* [#53](https://github.com/bbulpett/zebra-zpl/pull/53): Added support for symbol types, fixed other bugs with the `Graphic` class, updated specs - [@mtking2](https://github.com/mtking2)
* [#50](https://github.com/bbulpett/zebra-zpl/pull/50): Add support for image elements by incorporating the [img2zpl](https://github.com/mtking2/img2zpl) gem - [@mtking2](https://github.com/mtking2)
* [#49](https://github.com/bbulpett/zebra-zpl/pull/49): Fixed bug with `Barcode`'s `^BY` command. Added UPCA, UPCE, & EAN13 types - [@mtking2](https://github.com/mtking2)
* [#48](https://github.com/bbulpett/zebra-zpl/pull/48): Fixed bug breaking `Text` elements. Added rspecs for `Datamatrix` - [@mtking2](https://github.com/mtking2)
* [#45](https://github.com/bbulpett/zebra-zpl/pull/45): Add CHANGELOG & update README - [@mtking2](https://github.com/mtking2)
* [#44](https://github.com/bbulpett/zebra-zpl/pull/44): Update README & add more docs - [@mtking2](https://github.com/mtking2)
* [#43](https://github.com/bbulpett/zebra-zpl/pull/43): Add ZPL comment element - [@LagTag](https://github.com/LagTag)
* [#42](https://github.com/bbulpett/zebra-zpl/pull/42): Consolidate Graphic Elements to One Class. Deprecate `Box` class - [@LagTag](https://github.com/LagTag)
* [#41](https://github.com/bbulpett/zebra-zpl/pull/41): Ability to pass ZPL string to PrintJob - [@LagTag](https://github.com/LagTag)
* [#40](https://github.com/bbulpett/zebra-zpl/pull/40): Bold Text - [@LagTag](https://github.com/LagTag)
* [#39](https://github.com/bbulpett/zebra-zpl/pull/39): Fix specs + minor maintenance - [@mtking2](https://github.com/mtking2)
* [#36](https://github.com/bbulpett/zebra-zpl/pull/36): Add Datamatrix - [@rafaelmf3](https://github.com/rafaelmf3)
* [#33](https://github.com/bbulpett/zebra-zpl/pull/33): Remove the hardcoded attributes for the box element - [@LagTag](https://github.com/LagTag)
* [#32](https://github.com/bbulpett/zebra-zpl/pull/32): Added diagonal line graphic (^GD) - [@LagTag](https://github.com/LagTag)
* [#31](https://github.com/bbulpett/zebra-zpl/pull/31): Added Circle Graphic (^GC) - [@LagTag](https://github.com/LagTag)
* [#29](https://github.com/bbulpett/zebra-zpl/pull/29): Removed hard coded attributes in Text Element - [@LagTag](https://github.com/LagTag)
* [#27](https://github.com/bbulpett/zebra-zpl/pull/27): Added pdf417 support - [@LagTag](https://github.com/LagTag)
* [#25](https://github.com/bbulpett/zebra-zpl/pull/25): Don't Overwrite Element Widths - [@LagTag](https://github.com/LagTag)

### 1.0.5 (2018/10/25)

* [#22](https://github.com/bbulpett/zebra-zpl/pull/22): update label print density range from 0-6 to 0-15 - [@steve-abrams](https://github.com/steve-abrams)
* [#21](https://github.com/bbulpett/zebra-zpl/pull/21): Support QR codes (fixed) - [@mtking2](https://github.com/mtking2)
* [#20](https://github.com/bbulpett/zebra-zpl/pull/20): Fix incorrect raw flag - [@mtking2](https://github.com/mtking2)

### 1.0.4 (2017/10/27)

* [#15](https://github.com/bbulpett/zebra-zpl/pull/15): Raw ZPL support - [@bbulpett](https://github.com/bbulpett)

### 1.0.3 (2017/06/12)

* [#14](https://github.com/bbulpett/zebra-zpl/pull/14): Version bump to 1.0.3 - [@bbulpett](https://github.com/bbulpett)
* [#13](https://github.com/bbulpett/zebra-zpl/pull/13): Windows Printing Support - [@mtking2](https://github.com/mtking2)

### 1.0.2 (2017/04/27)

* [ead84a4](https://github.com/bbulpett/zebra-zpl/commit/ead84a4170f291e9a121263ac0ce577b9b5b21ba): Revert to Unix-only `lp` - [@bbulpett](https://github.com/bbulpett)

### 1.0.1 (2017/04/26)

* [b5e3f3e](https://github.com/bbulpett/zebra-zpl/commit/b5e3f3ea41960ce953073dcf1b09c28047a17b0d): Attempt `lpr` for Windows if Unix `lp` fails - [@bbulpett](https://github.com/bbulpett)
* [3858b33](https://github.com/bbulpett/zebra-zpl/commit/3858b332491d7afe34277d43530e0da7462da2b1): Use SSL for homepage in gemspec - [@bbulpett](https://github.com/bbulpett)

### 1.0.0 (2017/04/26)

* [#10](https://github.com/bbulpett/zebra-zpl/pull/10): Add side margins - [@bbulpett](https://github.com/bbulpett)
* [#9](https://github.com/bbulpett/zebra-zpl/pull/9): Add padding to sides for text blocks - [@bbulpett](https://github.com/bbulpett)
* [#8](https://github.com/bbulpett/zebra-zpl/pull/8): Add rotation to zpl builders - [@bbulpett](https://github.com/bbulpett)
* [#7](https://github.com/bbulpett/zebra-zpl/pull/7): Add international text support and apply label width to zpl builder methods - [@bbulpett](https://github.com/bbulpett)
* [#6](https://github.com/bbulpett/zebra-zpl/pull/6): Font modifications - [@bbulpett](https://github.com/bbulpett)
* [#5](https://github.com/bbulpett/zebra-zpl/pull/5): Restore barcode functionality - [@bbulpett](https://github.com/bbulpett)
* [#4](https://github.com/bbulpett/zebra-zpl/pull/4): Orientation module - [@bbulpett](https://github.com/bbulpett)
* [#3](https://github.com/bbulpett/zebra-zpl/pull/3): Restore zpl barcode logic - [@bbulpett](https://github.com/bbulpett)
* [#2](https://github.com/bbulpett/zebra-zpl/pull/2): ZPL barcodes tested and working - [@bbulpett](https://github.com/bbulpett)
* [#1](https://github.com/bbulpett/zebra-zpl/pull/1): Convert zpl method, class, and file namings - [@bbulpett](https://github.com/bbulpett)
