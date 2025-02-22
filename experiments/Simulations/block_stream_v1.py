# The below code implements block streaming matrix multiplication for input square matrices
# This code logic is to be understood for implementing it on RTL

import numpy as np

class BlockStream:
    """
    A class to perform block-wise matrix multiplication and verify the result.

    Attributes:
        A (np.ndarray): The first input matrix.
        B (np.ndarray): The second input matrix.
        C (np.ndarray): The resulting matrix from block-wise multiplication.
        BLOCK_SIZE (int): The size of the blocks used in multiplication.
        MATRIX_SIZE (int): The size of the matrices.

    Methods:
        block_multiply(): Performs block-wise multiplication of matrices A and B.
        verify_direct_multiplication(): Verifies the block-wise multiplication result against direct multiplication.
        test(): Executes block-wise multiplication and verification.
    """
    def __init__(self, A, B):
        self.A = A
        self.B = B
        self.C = np.zeros((MATRIX_SIZE, MATRIX_SIZE), dtype=int)
        self.BLOCK_SIZE = 3
        self.MATRIX_SIZE = 9
    
    def block_multiply(self):
        """
        Performs block-wise multiplication of matrices A and B, storing the result in matrix C.

        Iterates over the matrices in blocks of size BLOCK_SIZE, multiplying corresponding blocks
        from matrices A and B, and accumulating the results into the corresponding block of matrix C.
        Prints intermediate and final results for each block during the computation.
        """
        for i in range(0, MATRIX_SIZE, BLOCK_SIZE):  # Rows - blocks
            for j in range(0, MATRIX_SIZE, BLOCK_SIZE):  # Columns - blocks
                print(f"\nComputing block C[{i}:{i+BLOCK_SIZE}, {j}:{j+BLOCK_SIZE}]")
                for k in range(0, MATRIX_SIZE, BLOCK_SIZE):  # Intermediate sum for accumulation
                    # code to extract the 3x3 blocks for matrix multiplication
                    A_block = self.A[i:i+BLOCK_SIZE, k:k+BLOCK_SIZE]
                    B_block = self.B[k:k+BLOCK_SIZE, j:j+BLOCK_SIZE]

                    # Multiplying the blocks
                    product_block = np.dot(A_block, B_block)
                    print(f"\nA Block ({i}:{i+BLOCK_SIZE}, {k}:{k+BLOCK_SIZE}):\n", A_block)
                    print(f"\nB Block ({k}:{k+BLOCK_SIZE}, {j}:{j+BLOCK_SIZE}):\n", B_block)
                    print(f"\nIntermediate Product Block:\n", product_block)

                    # Accumulation of results into the final blocks
                    self.C[i:i+BLOCK_SIZE, j:j+BLOCK_SIZE] += product_block

                print(f"\nUpdated C Block [{i}:{i+BLOCK_SIZE}, {j}:{j+BLOCK_SIZE}]:\n", 
                    self.C[i:i+BLOCK_SIZE, j:j+BLOCK_SIZE])
        
        print("\nFinal Product Matrix C (Block-wise Computed):\n", self.C)
    
    def verify_direct_multiplication(self):
        """
        Verifies the correctness of block-wise matrix multiplication by comparing it
        with direct matrix multiplication.

        Computes the product of matrices A and B using direct multiplication and
        compares the result with the block-wise computed matrix C. Prints the
        direct multiplication result and asserts the equality of both results,
        raising an error if they do not match.
        """
        self.C_direct = np.dot(A, B)
        print("\nProduct Matrix C (Direct Multiplication):\n", self.C_direct)
        assert np.array_equal(self.C, self.C_direct), "Block-wise computation is incorrect!"
        print("\nBlock-wise multiplication is correct!")
    
    def test(self):
        """
        Executes the block-wise matrix multiplication and verifies its correctness.

        Calls the block_multiply method to perform the multiplication and the
        verify_direct_multiplication method to ensure the result matches direct
        matrix multiplication.
        """
        self.block_multiply()
        self.verify_direct_multiplication()

#__main__#

if __name__ == "__main__":
    # Define matrix dimensions
    BLOCK_SIZE = 3
    MATRIX_SIZE = 9

    # Generate two random 9x9 matrices
    np.random.seed(0)  
    A = np.random.randint(1, 10, (MATRIX_SIZE, MATRIX_SIZE))
    B = np.random.randint(1, 10, (MATRIX_SIZE, MATRIX_SIZE))
    print("Matrix A:\n", A)
    print("\nMatrix B:\n", B)

    obj = BlockStream(A, B)
    obj.test()