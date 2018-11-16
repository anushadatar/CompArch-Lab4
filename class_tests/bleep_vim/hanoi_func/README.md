# Recursive Tower of Hanoi assembly test

Simple test of recursive function calls

The answer will be the number of steps it takes to complete a Hanoi puzzle with n disks.

## Expected results

Computes Hanoi(4) + Hanoi(8) = 15 + 255 = 270.

Equivalent C code:

```C
     int hanoi(int n) {
         if (n == 1) return 1;  // Base case
         int hanoi_1 = Hanoi(n - 1);
         return 2*hanoi_1+1;
     }

     int hanoi_test(arg0, arg1) {
         return hanoi(arg0) + hanoi(arg1);
     }
```

Follows standard MIPS calling conventions:
 - arguments in `$a0` and `$a1` for `hanoi_test`
 - return value in `$v0`

## Memory layout requirements

No .data section required.

## Instructions required

 `add, addi, bne, lw, sw, j, jal, jr`

(all from basic subset)
