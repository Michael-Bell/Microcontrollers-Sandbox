#include <stdio.h>

void main() {
    /*
     * This will reverse the list without sorting
  */

    int count = 10;
    int myArray[10] = {1,2,3,4,5,10,9,8,7,6};
                        // 6,7,8,9,10,5,4,3,2,1
    int temp;
    int tempArray[10];
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