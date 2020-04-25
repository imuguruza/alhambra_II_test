https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278
https://embeddedthoughts.com/2016/07/29/driving-a-vga-monitor-using-an-fpga/
https://www.fpga4fun.com/PongGame.html
https://github.com/mystorm-org/BlackIce-II/wiki/PLLs

VGA Standard
http://caxapa.ru/thumbs/361638/DMTv1r11.pdf


- Create a 25 MHz clock

icepll -i 10 -o 25

F_PLLIN:    10.000 MHz (given)
F_PLLOUT:   25.000 MHz (requested)
F_PLLOUT:   25.000 MHz (achieved)

FEEDBACK: SIMPLE
F_PFD:   10.000 MHz
F_VCO:  800.000 MHz

DIVR:  0 (4'b0000)
DIVF: 79 (7'b1001111)
DIVQ:  5 (3'b101)

FILTER_RANGE: 1 (3'b001)

