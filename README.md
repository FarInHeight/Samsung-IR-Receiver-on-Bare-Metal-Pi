# Embedded-Systems-Project

The proposed project consists of using an IR receiver to capture commands sent by a remote controller and displaying them on an LCD display, along with the name of the pressed buttons.

<div align="center">
    <img src="./images/project_photo.jpg" width="800" class="center" />
</div>

---
> **IMPORTANT**: A complete overview of the project, including the necessary hardware, is available in [documentation.pdf](docs/documentation.pdf).
---

## Prerequisites

Your micro SD card must contain the following files:
- `bootcode.bin`;
- `config.txt`;
- `fixup.dat`;
- `start4.elf}`;
- `kernel7.img` (which contains `pijFORTHos`);
- `bcm2711-rpi-4-b.dtb`.

And the `config.txt` file must contain the following uncommented options:

```
dtparam=i2c_arm=on

dtparam=audio=on

dtoverlay=vc4-fkms-v3d
max_framebuffers=2
enable_uart=1
dtoverlay=w1-gpio,gpiopin=26

enable_uart=1
dtoverlay=w1-gpio,gpiopin=26
```

## How to run

To run the project, download the repository using
```
git clone https://github.com/FarInHeight/Embedded-Systems-Project.git
```

First, using Pi 4, verify the LCD IIC slave address using:
```
sudo apt-get install i2c-tools
i2cdetect -y 1
```

and change the slave address (contained in `i2c.f`) accordingly.
If you are using a Pi 3 Model B or Model B+, change the constant `PERI_BASE` in `utils.f` to `3F000000`.

After that, download `picocom` and `minicom`, load `pijFORTHos` into the micro SD card and change the shell `#!/bin/zsh` to your shell.

Change execution permissions as
```
chmod u+x unify_and_uncomment.py
chmod u+x create_program.sh
```
and run the script `./create_program.sh`.

Finally:
- connect the Pi and the serial UART to your terminal;
- run ``` picocom --b 115200 <your UART> --send "ascii-xfr -sv -l100 -c10" --imap delbs ```;
- press <kbd>Ctrl</kbd> + <kbd>A</kbd> and <kbd>Ctrl</kbd> + <kbd>S</kbd>;
- load the file `program.f` generated by `./create_program.sh`;
- start the program by typing `MAIN` and pressing <kbd>Enter</kbd>.

At this point you can disconnect the UART and enjoy the project.

## License
[MIT License](LICENSE)