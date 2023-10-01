# 2D Thermal Image to 1D Cooling Fin Model

This project focuses on approximating a 2D thermal image of a foam-like material into a 1D cooling fin model.
The primary objective is to predict the values of h/k (heat transfer coefficient over thermal conductivity) and
A_h/A_k (conduction effective area over thermal conduction cross section)
by fitting an analytical solution to experimental results.

## Overview

The project consists of two main parts:

1. **Data Acquisition**: In this section, we acquire and preprocess the thermal image data. We import the data, perform edge detection,
                         identify the region of interest, and calculate the average temperature profile of the sample.

3. **Fitting to Cooling Fin Model**: Here, we fit the experimental data to a 1D cooling fin model using a non-linear least squares fitting approach.
                                     This model allows us to estimate parameters such as h/k (heat transfer coefficient over thermal conductivity)
                                     and A_h/A_k (cross-sectional area ratio).

## Files and Usage

- `Thermal_image.m`: The main MATLAB script that executes the entire workflow. It imports the data, processes it, and performs the fitting.

- `Image.csv`: The input thermal image data in CSV format.

- `Thermal Image.png`: A saved thermal image with marked regions of interest and average pixel values.

- `Thermal Distribution.png`: A plot showing the fitted cooling fin model and the experimental data.
- 

## Results

After running the script, you will obtain the following results:

- Estimated values of h/k (heat transfer coefficient over thermal conductivity).
- Estimated values of A_h/A_k (cross-sectional area ratio).
- Visualization of the fitted cooling fin model compared to the experimental data.


