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

; This tests the behaviour of IE and IF flags by forcing a serial
; interrupt with a write to IF. The interrupt handler increments
; E, so we can track how many times the interrupt has been
; triggered

; Verified results:
;   pass: DMG, MGB, SGB, SGB2, CGB, AGB, AGS
;   fail: -

.incdir "../common"
.include "common.s"

  ; Make sure IE, IF, and E are all $00
  di
  xor a
  ld (IF), a
  ld (IE), a
  ld e, a
  ei

  ; Write serial interrupt bit to IF and wait
  ; Since IE is $00, we are *not* expecting an
  ; interrupt
  ld hl, IF
  ld a, INTR_SERIAL
  ld (hl), a
  nops 64
  ld b, e
  ld a, (hl)
  ld c, a
  ; B contains counter E value
  ; C contains register IF value

  ; Write serial interrupt bit to IE and wait
  ; We already wrote it to IF, so now we expect
  ; one interrupt trigger
  ld hl, IE
  ld a, INTR_SERIAL
  ld (hl), a
  nops 64
  ld d, e
  ld hl, IF
  ld a, (hl)
  ld e, a
  ; D contains counter E value
  ; E contains register IF value

test_finish:
  save_results
  assert_b $00
  assert_c $E8
  assert_d $01
  assert_e $E0
  jp process_results

.org INTR_VEC_SERIAL
  inc e
  reti
