#include <stdio.h>
/*
*   This code will take myArray[11], sort it with insert sort and then reverse it. 
*/
void main() {
    /*
  * Insert Sort
  */
    int count = 11;
    int myArray[11] = {5,4,6,3,7,2,8,1,9,10,0};

    int  temp;
    for(int i =1; i<count; i++){
        for(int x=i; x>0; x--) {

            if(myArray[x] < myArray[x-1]){
                temp = myArray[x-1];
                myArray[x-1] = myArray[x];
                myArray[x] = temp;
            }
        }
        temp = i;
    }

    temp = temp;  // Junk statement to hold the debugger

    /*
     * Reversing the array
     * */

    int tempArray[11];
    int loopCount = count-1;
    for(int i=0; i<count ; i++){
    tempArray[loopCount] = myArray[i];
    loopCount--;
    }
    for(int i=0; i<count ; i++){
        myArray[i]=tempArray[i];
    }
    temp = temp;  // Junk statement to hold the debugger
    return ;
}
