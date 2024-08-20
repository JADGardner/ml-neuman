
import os
import sys
from PIL import Image

def convert_png_to_jpg(input_folder, output_folder):
    # Create the output folder if it doesn't exist
    if not os.path.exists(output_folder):
        os.makedirs(output_folder)

    # Iterate through all files in the input folder
    for filename in os.listdir(input_folder):
        if filename.lower().endswith('.png'):
            # Construct the full file paths
            input_path = os.path.join(input_folder, filename)
            output_path = os.path.join(output_folder, os.path.splitext(filename)[0] + '.jpg')

            try:
                # Open the PNG image
                with Image.open(input_path) as img:
                    # Convert to RGB mode if the image has an alpha channel
                    if img.mode in ('RGBA', 'LA'):
                        background = Image.new('RGB', img.size, (255, 255, 255))
                        background.paste(img, mask=img.split()[3])  # 3 is the alpha channel
                        img = background

                    # Save as JPG
                    img.save(output_path, 'JPEG', quality=100)
                print(f"Converted: {filename}")
            except Exception as e:
                print(f"Error converting {filename}: {str(e)}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python script.py <input_folder> <output_folder>")
        sys.exit(1)

    input_folder = sys.argv[1]
    output_folder = sys.argv[2]

    if not os.path.isdir(input_folder):
        print(f"Error: {input_folder} is not a valid directory")
        sys.exit(1)

    convert_png_to_jpg(input_folder, output_folder)
    print("Conversion complete!")