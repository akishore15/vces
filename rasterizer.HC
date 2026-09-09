#define SCREEN_WIDTH  640
#define SCREEN_HEIGHT 480

// Base memory address representing our virtual hardware VRAM
U32 *VRAM_START = 0x7FFF0000; 

// 1. Core Point-Plotting Function
U0 PlotPixel(I64 x, I64 y, U32 color)
{
  // Boundary Guard: Ensure the coordinates exist on the physical screen
  if (x >= 0 && x < SCREEN_WIDTH && y >= 0 && y < SCREEN_HEIGHT) {
    // Calculate 1D array index: (Y * Width) + X
    I64 offset = (y * SCREEN_WIDTH) + x;
    VRAM_START[offset] = color;
  }
}

// 2. Bresenham's Line Rasterizer Function
U0 RasterizeLine(I64 x0, I64 y0, I64 x1, I64 y1, U32 color)
{
  I64 dx =  AbsI64(x1 - x0);
  I64 dy = -AbsI64(y1 - y0);
  I64 sx = x0 < x1 ? 1 : -1;
  I64 sy = y0 < y1 ? 1 : -1;
  I64 error = dx + dy; // Main mathematical error boundary variable
  I64 e2;              // Temporary evaluation variable

  while (TRUE) {
    PlotPixel(x0, y0, color); // Paint the current calculated coordinate
    
    // Break the loop when the line hits its destination coordinate
    if (x0 == x1 && y0 == y1) break; 
    
    e2 = 2 * error;
    
    // Adjust coordinates based on the mathematical error offset
    if (e2 >= dy) {
      error += dy;
      x0 += sx;
    }
    if (e2 <= dx) {
      error += dx;
      y0 += sy;
    }
  }
}
