# Mooneye GB

Mooneye GB is a Gameboy emulator written in Rust.

The main goals of this project are accuracy and documentation. Some existing emulators are very accurate (Gambatte, Gameboy Online, BGB >= 1.5) but are not documented very clearly, so they are not that good references for emulator developers. I want this project to document as clearly as possible *why* certain behaviour is emulated in a certain way. This also means writing a lot of test ROMs to figure out corner cases and precise behaviour on real hardware.

Non-goals:

* CGB (Color Gameboy) support. It would be nice, but I want to make the normal Gameboy support extremely robust first.
* A good debugger. A primitive debugger exists for development purposes, and it is enough.
* A user interface. Building native UIs with Rust is a bit painful at the moment.

**Warning**:

* Project is WIP
* Doesn't work properly without a boot ROM

## Accuracy

This project already passes Blargg's cpu\_instrs, instr\_timing, and mem\_timing-2 tests.

Things that need significant work:

* GPU emulation accuracy
* APU emulation in general (Blargg's dmg_sound-2 works fairly well, but that's just the beginning)

There's tons of documentation and tons of emulators in the internet, but in the end I only trust real hardware. I follow a fairly "scientific" process when developing emulation for a feature:

1. Think of different ways how it might behave on real hardware
2. Make a hypothesis based on the most probable behaviour
3. Write a test ROM for such behaviour
4. Run the test ROM on real hardware. If the test ROM made an invalid hypothesis, go back to 1.
5. Replicate the behaviour in the emulator

All test ROMs are manually run with a Gameboy Pocket (model MGB-001) and a Gameboy Advance SP (model AGS-101).

## Performance

**Always compile in release mode if you care about performance!**

On a i7-3770K desktop machine I can usually run ROMs with 2000 - 4000% speed. Without optimizations the speed drops to 150 - 200%, which is still fine for development purposes.

## Running the emulator

1. Acquire a Gameboy bootrom, and put it to `~/.mooneye-gb/boot.bin`
2. `cargo build --release`
3. `cargo run --release -- PATH_TO_GAMEBOY_ROM`

### Gameboy keys

| Gameboy | Key        |
| ------- | ---------- |
| Dpad    | Arrow keys |
| A       | Z          |
| B       | X          |
| Start   | Return     |
| Select  | Backspace  |

### Other keys

| Function     | Key       |
| ------------ | --------- |
| Fast forward | Shift     |
| Debug break  | Home      |
| Debug step   | Page Down |
| Debug run    | End       |