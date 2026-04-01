#!/usr/bin/env python3
"""
Generate app icons from the full logo - Improved version.
Extracts the circular icon portion and creates Android icon sizes.
Keeps the original colors intact.
"""

from PIL import Image
import os

# Load the full logo
logo_path = r"f:\Resume Pilot app\flutter_app\assets\icons\Logo.png"
logo = Image.open(logo_path)

print(f"Original logo size: {logo.size}")
print(f"Logo mode: {logo.mode}")

# The circular compass icon is roughly in the center-top portion
width, height = logo.size

# For pure icon: extract centered square region
# Since it's just an icon, use larger central region for better quality
crop_size = int(min(width, height) * 0.9)
left = (width - crop_size) // 2
top = (height - crop_size) // 2
right = left + crop_size
bottom = top + crop_size
icon_crop_box = (left, top, right, bottom)
icon_img = logo.crop(icon_crop_box)
print(f"Cropped icon size: {icon_img.size}")

# Resize to 512x512
icon_512 = icon_img.resize((512, 512), Image.Resampling.LANCZOS)

print(f"Resized icon size: {icon_512.size}")

# Android icon sizes
icon_sizes = {
    'mipmap-mdpi': 48,
    'mipmap-hdpi': 72,
    'mipmap-xhdpi': 96,
    'mipmap-xxhdpi': 144,
    'mipmap-xxxhdpi': 192,
}

base_path = r"f:\Resume Pilot app\flutter_app\android\app\src\main\res"

for dir_name, size in icon_sizes.items():
    # Resize the icon
    icon = icon_512.resize((size, size), Image.Resampling.LANCZOS)
    
    # Save to the appropriate directory
    output_dir = os.path.join(base_path, dir_name)
    output_path = os.path.join(output_dir, 'ic_launcher.png')
    
    # Create directory if it doesn't exist
    os.makedirs(output_dir, exist_ok=True)
    
    # Save as PNG (keep transparency/original format)
    icon.save(output_path, 'PNG')
    print(f"✓ Generated {dir_name}: {size}x{size} → {output_path}")

print("\n✅ App icons generated successfully!")
print("All ic_launcher.png files have been updated with your Resume Pilot logo icon.")
