# =========================
# PART 1: IMAGE TO .MEM FILE
# =========================

# Import required libraries
from google.colab import files      # For uploading/downloading files in Colab
import cv2                          # OpenCV for image processing
from google.colab.patches import cv2_imshow  # To display image in Colab

# Upload image file from local system
uploaded = files.upload()

# Read the image in grayscale mode (0 = grayscale)
img = cv2.imread('input.jpg', 0)

# Resize image to 128x128 (important for fixed hardware input size)
img = cv2.resize(img, (128, 128))

# Display the processed image
cv2_imshow(img)

# Flatten 2D image (128x128) into 1D array (16384 pixels)
flat = img.flatten()

# Create a .mem file and write pixel values in hexadecimal format
with open("input.mem", "w") as f:
    for pixel in flat:
        # Convert each pixel (0–255) to 2-digit hex and write line-by-line
        f.write("{:02x}\n".format(pixel))

# Download the generated .mem file (used in Verilog/FPGA)
files.download("input.mem")


# =========================
# PART 2: .MEM FILE TO IMAGE
# =========================

# Import required libraries
from google.colab import files
import numpy as np
import matplotlib.pyplot as plt

# Upload the output.mem file (generated from hardware/Verilog)
uploaded = files.upload()

# Define image dimensions (must match original size)
WIDTH = 128
HEIGHT = 128

# Read hex values from .mem file and convert to integers
with open("output.mem", "r") as f:
    pixels = [int(line.strip(), 16) for line in f]

# Convert list to NumPy array (8-bit unsigned integers)
pixels = np.array(pixels, dtype=np.uint8)

# Reshape 1D array back to 2D image (128x128)
image = pixels.reshape((HEIGHT, WIDTH))

# Display reconstructed image
plt.imshow(image, cmap='gray')
plt.title("Reconstructed Image from output.mem")
plt.axis('off')
plt.show()
