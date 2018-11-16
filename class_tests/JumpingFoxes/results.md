# Expected Results

## Multiply By 3 Test
At the end of execution of multiplyby3.asm the value in $a0 should be 12 (a hex value of c). You can also test that it works for different values by loading a different immediate value (instead of 4) into $t1 on line 3.

## Jump Branch Test
This test ends with an infinite loop in the end section. One should stop execution manually once the program has completed and check that the values in $t1 and $t2 are both equal to 10 (a hex value of a).

## Memory and Jump and Link Test
This test also ends with an infinite loop in the end section. One should stop execution manually once the program has completed and check that the value stored in $a0 is 8. If it is, then a value was successfully stored and loaded from memory and we were able to use jump and link to load the word then jump back to where we were before to add to the loaded word.
