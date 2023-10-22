# RISC-V Ripes MergeSort Algorithm

This is a simple RISC-V assembly implementation of the MergeSort algorithm using the Ripes simulator. The code was created with minimal assistance from ChatGPT, focusing on formatting and text replacement, while the logic and algorithm design were independently implemented.

## Description

The MergeSort algorithm is a divide-and-conquer sorting algorithm that efficiently sorts an array or list. This assembly code demonstrates how to implement MergeSort (Recursive) using the RISC-V architecture with the Ripes simulator.

## Usage

1. Open the Ripes simulator.
2. Load the assembly code into Ripes.
3. Compile and run the code to see the MergeSort algorithm in action.
4. Output will be present in the same data location as the input.
[NOTE: Intermediary spaces were used at addresses 0x05000000 and 0x02500000 (addresses are chosen arbitrarily) to initialise and act as Auxiliary spaces.]
## Test Cases

The code includes various test cases to ensure that the MergeSort algorithm works as expected. These test cases cover different scenarios, such as:

- Sorted and reverse-sorted arrays
- Random data
- Empty arrays
- Arrays with duplicate values
- Arrays with a wide range of values, including large values and negative numbers

These test cases help validate the correctness and robustness of the algorithm.

## Authorship

- The assembly code was designed and implemented by SpyceePlastic.
- Minor formatting and text replacement were done with the assistance of ChatGPT.

## License

This project is open-source and available under the MIT_LICENSE. You can find more details in the `MIT_LICENSE` file.

## Acknowledgments

Special thanks to the creators of Ripes and the RISC-V architecture for providing a platform to explore and implement algorithms in assembly language.

## Contact

For any inquiries or questions related to this project, please contact raikerritvik@gmail.com.

Happy sorting!
