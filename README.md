#### Introduction
This is the fourth assignment for the "Hardware Description Language" course at NSYSU.

The main target of this assignment - **Sobel Edge Operation with Shift-Register-Based Line Buffer**.

It mainly covers the following tasks:  
- Three multiplication-accumulation operations are required to compute the intensity of an image pixel.
- use the Sorbel convolution masks to find the vertical edges and horizontal edges from the intensity image.
- Write RTL code to fetch the original colored image from memory unit in the test bench, one pixel per cycle, and generate the corresponding intensity value which is stored in a line buffer (constructed with shift registers).
- Model the edge convolution hardware using RTL code and generate the edge map pixels (one pixel per cycle) which are sent to memory unit in testbench.
- Verify my Verilog codes both in the RTL level and in the gate level where the gate-level netlists are synthesized by Design Compiler.
