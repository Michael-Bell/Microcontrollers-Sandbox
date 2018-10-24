#include <stdio.h>

void main() {
    /*
     * If Number > 10 then we run Number/10
     * If number < 10 then we run number*10
  */

    int count = 5;
    int myArray[5] = {1, 4, 10, 20, 40};
                    // 2, 8, 20, 10, 20
    int temp;
    for(int i=0; i<count ; i++){
       if(myArray[i]>10) // less than but not equal.
       {
           // Divide by 10
           // Shift 1 bit to the right
           myArray[i] = myArray[i] >> 1;
       }
       else{ // if 10 OR lower
           // Multiply by 10
           // Shift 1 bit to the left
           myArray[i] = myArray[i] << 1;

       }
    }
    temp = temp;  // Junk statement to hold the debugger
    return ;
}
