.global plot_pixel_fast
.text
.align 2


plot_pixel_fast:
    // 1. Boundary Guards (Screen Width: 640, Height: 480)
    cmp     x0, #640            // Check if X >= 640
    b.ge    .L_out_of_bounds    // Reject if out of bounds
    cmp     x1, #480            // Check if Y >= 480
    b.ge    .L_out_of_bounds    // Reject if out of bounds
    cmp     x0, #0              // Check if X < 0
    b.lt    .L_out_of_bounds
    cmp     x1, #0              // Check if Y < 0
    b.lt    .L_out_of_bounds

    lsl     x4, x1, #9          // x4 = Y * 512
    lsl     x5, x1, #7          // x5 = Y * 128
    add     x4, x4, x5          // x4 = (Y * 512) + (Y * 128) = Y * 640
    add     x4, x4, x0          // x4 = (Y * 640) + X  (This is our 1D pixel index)

    // 3. Scale Index to Byte Memory Offset
    // Since each TrueColor pixel is 4 bytes (32-bit color), we multiply the index by 4
    lsl     x4, x4, #2          // x4 = index * 4 (Shift left by 2 bits)

    // 4. Memory Injection Blit
    str     w2, [x3, x4]       
    ret                        

.L_out_of_bounds:
    ret                         
