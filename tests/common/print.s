; This file is part of Mooneye GB.
; Copyright (C) 2014-2016 Joonas Javanainen <joonas.javanainen@gmail.com>
;
; Mooneye GB is free software: you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation, either version 3 of the License, or
; (at your option) any later version.
;
; Mooneye GB is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with Mooneye GB.  If not, see <http://www.gnu.org/licenses/>.

.macro print_string_literal ARGS string
  ld bc, _print_sl_data\@
  call print_string
  jr _print_sl_out\@
_print_sl_data\@:
  c_string string
_print_sl_out\@:
.endm

.bank 1 slot 1
.section "Runtime-Print" free
  ; Clobbers:
  ;   AF, BC, DE, HL
  print_load_font:
    ld hl, VRAM + $10
    ld de, font
    ld bc, FONT_SIZE
    call memcpy
    ret

  ; Inputs:
  ;   BC string address
  ; Clobbers:
  ;   AF, BC, HL
  print_string:
-   ld a, (bc)
    cp $00
    jr z, +
    ld (hl+), a
    inc bc
    jr -
+   ret

  ; Inputs:
  ;   A value
  ; Clobbers:
  ;   AF, BC, HL
  print_a:
    ld b, a
    swap b
    call print_digit
    swap b
    jr print_digit

  print_newline:
    ld a, l    
    and $1F
    xor $1F
    ld b, $00
    ld c, a
    inc c
    add hl, bc
    ret

  ; Inputs:
  ;   A value
  ; Clobbers:
  ;   AF, BC, HL
  print_digit:
    ld a, $0F
    and b
    cp $0a
    jr c, +
    add $07
+   add $30
    ld (hl+), a
    ret

  ; Inputs:
  ;   DE pointer to reg_dump
  ; Clobbers:
  ;   AF, BC, DE, HL
  print_regs:
    .macro __print_reg_pair ARGS reg_a reg_b
      inc de
      print_string_literal reg_a
      ld a, (de)
      call print_a

      dec de
      print_string_literal reg_b
      ld a, (de)
      call print_a

      inc de
      inc de
      call print_newline
    .endm

    __print_reg_pair "  A: " "  F: "
    __print_reg_pair "  B: " "  C: "
    __print_reg_pair "  D: " "  E: "
    __print_reg_pair "  H: " "  L: "

    ret
.ends

.bank 1 slot 1
.section "Font" free
font:
  ; 8x8 ASCII bitmap font by Darkrose
  ; http://opengameart.org/content/8x8-ascii-bitmap-font-with-c-source
  .incbin "font.bin" fsize FONT_SIZE
.ends
