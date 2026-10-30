from PIL import Image, ImageOps
img = Image.open("input.png").convert("L")
ImageOps.colorize(img, black="#e00000", white="#ffffff").save("output_red.png")