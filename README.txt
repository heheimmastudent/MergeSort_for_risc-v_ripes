# RISC-V Ripes MergeSort Algorithm

This repository contains two implementations of the MergeSort algorithm in RISC-V assembly. Tested for RISC-V 32-bit Single-cycle processor only.

## Description

The MergeSort algorithm is a divide-and-conquer sorting algorithm that efficiently sorts an array or list. This repository demonstrates two different implementations of MergeSort using the RISC-V architecture with the Ripes simulator.

### File Descriptions

- `mergeSort_naive.s`: This was the initial implementation of the MergeSort algorithm. It uses intermediary spaces at addresses 0x05000000 and 0x02500000 for auxiliary space. This implementation may not be the most efficient in terms of space management.

- `mergeSort_improved.s`: This is the latest version of the MergeSort algorithm. It utilizes only stack space and does not rely on external auxiliary space. This implementation is more space-efficient and should be preferred over the early version.

## Usage

1. Open the Ripes simulator.
2. Load the assembly code of your choice (`mergeSort_risc-v.s` or `MergeSort_recursive_ultra.s`) into Ripes.
3. Compile and run the code to see the MergeSort algorithm in action.
4. Output will be present in the same data location as the input.

## Test Cases

Both implementations include various test cases to ensure that the MergeSort algorithm works as expected. These test cases cover different scenarios, such as:

- Sorted and reverse-sorted arrays
- Random data
- Empty arrays
- Arrays with duplicate values
- Arrays with a wide range of values, including large values and negative numbers

These test cases help validate the correctness and robustness of the algorithm.

## Authorship

- The assembly code for both implementations was designed and implemented by SpyceePlastic.
- Minor formatting and text replacement were done with the assistance of ChatGPT.

## License

This project is open-source and available under the MIT License. You can find more details in the `MIT_LICENSE` file.

## Acknowledgments

Special thanks to the creators of Ripes and the RISC-V architecture for providing a platform to explore and implement algorithms in assembly language.

## Contact

For any inquiries or questions related to this project, please contact raikerritvik@gmail.com.

Happy sorting!
