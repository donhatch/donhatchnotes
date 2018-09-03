https://www.cups.org/doc/options.html

List printers
  lpstat -p -d
    (-p lists printers, -d shows default printer... in command line order)
Printer options:
  lpoptions -pgiftshop-color -l
    ...
    Resolution/Resolution: *600dpi 1200dpi
    ...
    ColorModel/Color Mode: CMYK *Gray
    ..

So, e.g.:
  lpr -Pgiftshop-color -oResolution=1200dpi -oColorModel=CMYK printer_dpi_test_pattern.ps

