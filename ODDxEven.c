/*
 * File:   ODDxEVEN.c
 * Author: michael
 *
 * Created on October 24, 2018, 12:55 PM
 */

#include <p18cxxx.h>

void main() {
    int myArray[] = {1,2,3,4,5,6,7,8,9,10, 0, 0};
    int odd = 0, even =0, zero=0;
    int count = sizeof(myArray)/sizeof(myArray[0]); // Take number of bytes of entire array and divide by bytes of 1 entry to get total number of entries. 
    for (int i=0; i< count; i++){                   // This allows quick writing of new values, might not be best practice though...
        if(myArray[i]%2 != 0 )
        {
            // Odd, Non-Zero Number
            odd+=1;
        }
        else if (myArray[i] == 0){
            // Zero
            zero+=1;
        }
        else {
            // Even, Non-Zero Number
            even += 1;
        }
    }
   return ;
}
