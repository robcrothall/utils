from PIL import Image, ImageDraw

img = Image.open("BetterPay_Advert_noBorder.png").convert("RGB")
w, h = img.size

thickness = 4          # border thickness in pixels
colour = "#e00000"     # same red as the logo
margin = 0             # gap between the image edge and the border

draw = ImageDraw.Draw(img)
for i in range(thickness):
    draw.rectangle(
        [margin + i, margin + i, w - 1 - margin - i, h - 1 - margin - i],
        outline=colour,
    )

img.save("BetterPay_Advert_border.png")