# FPGA-Based Edge Detection (Sobel Hardware + Canny Simulation)

## 📌 Overview

This project presents implementations of two edge detection algorithms: **Sobel** and **Canny**.

* The **Sobel algorithm is fully implemented on FPGA hardware** for real-time processing.
* The **Canny algorithm is implemented and verified through simulation only**, demonstrating algorithmic correctness and performance analysis.

The system operates on grayscale images of resolution **128 × 128 (16384 pixels)**.

---

# 🔹 Part 1: Sobel Edge Detection (Hardware Implementation)

## ⚙️ Description

The Sobel operator is implemented as a **fully functional FPGA design** using Verilog. It computes image gradients using fixed 3×3 kernels and produces edge-detected output in real time.

## 🏗️ Key Features

* Real-time processing on FPGA
* Fully pipelined architecture
* VGA output display support
* Low hardware resource utilization

## 📁 Relevant Files

```
sobel.v  
sobel_edge.v  
edge_top.v  
edge_controller.v  
line_buffer.v  
window3x3.v  
input_frame_buffer.v  
output_frame_buffer.v  
vga_display.v  
vga_sync.v  
constraint.xdc  
edge_tb.v  
```

## ▶️ How to Run (Hardware)

1. Open **Xilinx Vivado**
2. Create RTL project and add Sobel-related files
3. Add `constraint.xdc`
4. Synthesize → Implement → Generate Bitstream
5. Program **Nexys A7 (Artix-7 XC7A100T)**
6. Observe output on VGA display

## 📊 Sobel Results

* Total Pixels: **16384**
* Edge Pixels: **4820**
* Edge Density: **29.41%**
* Observation: High edge response but noisy output

---

# 🔹 Part 2: Canny Edge Detection (Simulation Only)

## ⚙️ Description

The Canny edge detection algorithm is implemented in Verilog and verified using simulation. It includes all standard stages but is **not deployed on FPGA hardware** due to higher complexity.

## 🧩 Pipeline Stages

1. Gaussian Blur
2. Gradient Computation (Sobel)
3. Non-Maximum Suppression (NMS)
4. Double Thresholding
5. Hysteresis

## 📁 Relevant Files

```
canny_top.v  
gaussian_blur.v  
nms.v  
double_threshold.v  
hysteresis.v  
line_buffer.v  
window3x3.v  
canny_tb.v  
```

## ▶️ How to Run (Simulation)

1. Open **Vivado Simulator (xsim)**
2. Add Canny-related files
3. Set testbench → `canny_tb.v`
4. Provide input file → `input.mem`
5. Run simulation

## 📊 Canny Results

* Total Pixels: **16384**
* Edge Pixels: **2689**
* Edge Density: **16.41%**
* Observation: Thin, accurate, and noise-free edges

---

# ⚡ Hardware Platform

* Board: **Nexys A7**
* FPGA: **Xilinx Artix-7 (XC7A100T)**

---

# 📈 Comparison Summary

| Metric         | Sobel (Hardware) | Canny (Simulation)          |
| -------------- | ---------------- | --------------------------- |
| Implementation | FPGA             | Simulation                  |
| Speed          | Real-time        | Not implemented on hardware |
| Edge Quality   | Noisy            | Refined                     |
| Complexity     | Low              | High                        |

---

# 🚀 Applications

* Computer Vision
* Embedded Systems
* Robotics
* Industrial Inspection

---

## 👨‍💻 Group_6- Pixel Pulse

- Swasti Jain BT23ECE016 
- Shreyash Kale BT23ECE092  
- Hrudul S BT23ECE097  
- Dhanush Rathod BT23ECE120  

---

# 📌 Notes

* Sobel design is optimized for FPGA deployment
* Canny design is validated at simulation level
* `.mem` files are used for input/output handling
