#include <stdio.h>

// Function printArray will take the length of array and the array, then print it to the output window
void printArray(int length, int array[]) {
    // Iterate through each element of the array
    for (int i = 0; i < length; i++) {
        // print each element to output window with dividers
        printf("(%d)|", array[i]);
    }
    // Print a newline character at the end
    printf("\n");
    return;
}

int main() {
    int count = 0; // This is the size of the array
    printf("Enter the length of the array: ");
    scanf("%d", &count);            // Scan next line for a integer length; No error handling for bad input though
    int myArray[count];             // Make an array of specified length
    int dupeArray[count];
    for (int i = 0; i < count; i++) {    // Iterate through each element
        printf("Enter Value %d:", i);
        scanf("%d", &myArray[i]);    // And fill with input from the console
        dupeArray[i] = myArray[i];  // Copy to duplicate array
    }

    // Just echo back the data to provide a reference
    printf("Your Array is from Array[0] to Array[%d] and has these values:\n", count - 1);
    printArray(count, myArray); // Calling the pre-made function
    printf("Reversing Array:\n");


    /*
     * Iterate 1/2 of the element count. Since we swap 2 cells each iteration, 50% is enough
     * On ODD count arrays the center value stays put, so the remainder from Count/2 is thrown away
     * Each iteration swaps low value myArray[i] with high value myArray[loopCount]
     */
    int temp;                           // Temporary storage variable
    int loopCount = count - 1;            // High Value Address, Starts at highest cell
    for (int i = 0; i < (count / 2); i++) {
        temp = myArray[loopCount];     // Copy the higher value to a temporary variable
        myArray[loopCount] = myArray[i]; // Copy Low value to the high Value cell
        myArray[i] = temp;               // Copy original High Value from temp location to low value cell
        // The cells are now swapped
        loopCount--;                   // Decrement the High value cell counter by 1
        printf("Iteration %d: ", i);    // Print out the incremental array value
        printArray(count, myArray);
    }

    // Print out the start/end result for comparison
    printf("The array is now sorted to the new values\n");
    printf("Original: ");
    printArray(count, dupeArray);
    printf("Reversed: ");
    printArray(count, myArray);
    return 0;
}
