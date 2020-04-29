Useful links to understand vga :

https://www.digikey.com/eewiki/pages/viewpage.action?pageId=15925278
https://embeddedthoughts.com/2016/07/29/driving-a-vga-monitor-using-an-fpga/
https://www.fpga4fun.com/PongGame.html

pll explanation:

https://github.com/mystorm-org/BlackIce-II/wiki/PLLs

VGA Standard
http://caxapa.ru/thumbs/361638/DMTv1r11.pdf


- Create a 25.125 MHz clock

$ icepll -i 12 -o 25.175

F_PLLIN:    12.000 MHz (given)
F_PLLOUT:   25.175 MHz (requested)
F_PLLOUT:   25.125 MHz (achieved)

FEEDBACK: SIMPLE
F_PFD:   12.000 MHz
F_VCO:  804.000 MHz

DIVR:  0 (4'b0000)
DIVF: 66 (7'b1000010)
DIVQ:  5 (3'b101)

FILTER_RANGE: 1 (3'b001)
