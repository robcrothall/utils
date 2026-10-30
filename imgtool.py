"""Small image helper: recolour black-on-white images, or add a coloured border.

Usage:
  python imgtool.py recolour input.png                 -> input_red.png
  python imgtool.py recolour input.png -c "#0055cc"    -> input_red.png in blue
  python imgtool.py border input.png                   -> input_border.png
  python imgtool.py border input.png -t 6 -p 20        -> thicker border, 20 px white padding
  python imgtool.py border input.png -o final.png      -> choose the output name

Options (both commands):  -c colour (hex, default #e00000)   -o output file
Border only:              -t thickness in px (default 4)     -p white padding in px (default 0)
"""
import argparse
from pathlib import Path

from PIL import Image, ImageDraw, ImageOps


def recolour(src, colour):
    grey = Image.open(src).convert("L")
    return ImageOps.colorize(grey, black=colour, white="#ffffff")


def border(src, colour, thickness, padding):
    img = Image.open(src).convert("RGB")
    if padding:
        img = ImageOps.expand(img, border=padding, fill="white")
    w, h = img.size
    draw = ImageDraw.Draw(img)
    for i in range(thickness):
        draw.rectangle([i, i, w - 1 - i, h - 1 - i], outline=colour)
    return img


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("command", choices=["recolour", "border"])
    p.add_argument("input")
    p.add_argument("-c", "--colour", default="#e00000")
    p.add_argument("-o", "--output")
    p.add_argument("-t", "--thickness", type=int, default=4)
    p.add_argument("-p", "--padding", type=int, default=0)
    a = p.parse_args()

    src = Path(a.input)
    suffix = "_red" if a.command == "recolour" else "_border"
    out = Path(a.output) if a.output else src.with_name(src.stem + suffix + ".png")

    if a.command == "recolour":
        result = recolour(src, a.colour)
    else:
        result = border(src, a.colour, a.thickness, a.padding)
    result.save(out)
    print("Saved", out)


if __name__ == "__main__":
    main()
