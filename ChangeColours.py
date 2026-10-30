from PIL import Image, ImageOps
img = Image.open("BetterPay_logo.png").convert("L")
ImageOps.colorize(img, black="#e00000", white="#ffffff").save("BetterPay_logo_red.png")