from pdf2image import convert_from_path
import matplotlib.pyplot as plt
import os
from PIL import Image


# Define the paths to your PDF files
png_files = [
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot1_ncs_55.png', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot2_ncs_11.png', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot3_ncs_cln.png',
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot4_ns_ncs_55.png', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot5_ns_ncs_11.png', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot6_ns_ncs_cln.png'
]



# Define the paths to your PDF files
pdf_files = [
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot1_ncs_55.pdf', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot2_ncs_11.pdf', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot3_ncs_cln.pdf',
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot4_ns_ncs_55.pdf', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot5_ns_ncs_11.pdf', 
    '/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/Plot6_ns_ncs_cln.pdf'
]
'''
# Convert each PDF file to a PNG image
for pdf_file in pdf_files:
    # Generate PNG filename by replacing .pdf with .png
    png_file = pdf_file.replace('.pdf', '.png')

    # Convert PDF to images; this assumes each PDF has only one page
    images = convert_from_path(pdf_file, 300)  # 300 DPI for high quality

    # Save the first page as PNG (index 0)
    images[0].save(png_file, 'PNG')

print("Conversion completed.")
'''


# Sort files to ensure they are in the correct order
png_files.sort()

# Create a figure and a set of subplots in landscape format
fig, axes = plt.subplots(nrows=2, ncols=3, figsize=(15, 10))  # Adjusted for landscape

# Flatten the axes array for easy iteration
axes = axes.flatten()

# Iterate over the image files and axes
for ax, img_file in zip(axes, png_files):
    # Open an image file
    img = Image.open(img_file)
    # Display the image
    ax.imshow(img)
    ax.axis('off')  # Hide axes

# Adjust layout and save the result as a single image
plt.tight_layout()
plt.savefig('/Users/shashankpritam/github/Insertion-Bias-TE/images/fig_pdf/combined_Figure_5.png', format='png')
plt.close()