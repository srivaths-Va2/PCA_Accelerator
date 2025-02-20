import torch
import time
import pandas as pd
import scipy.optimize as opt
import matplotlib.pyplot as plt

# Ensure we're using the CPU
device = torch.device("cpu")

def ensure_on_cpu(tensor, name="Tensor"):
    """
    Ensures that a given tensor is located on the CPU.

    Parameters:
        tensor (torch.Tensor): The tensor to check.
        name (str): The name of the tensor, used in the error message.

    Raises:
        RuntimeError: If the tensor is not on the CPU device.
    """
    if tensor.is_cuda:
        raise RuntimeError(f"{name} is on {tensor.device}, expected CPU!")

def matrix_multiplication(A, B):
    """
    Perform matrix multiplication of two tensors using PyTorch on the CPU.

    Parameters:
        A (torch.Tensor): The first matrix, expected to be on the CPU.
        B (torch.Tensor): The second matrix, expected to be on the CPU.

    Returns:
        torch.Tensor: The result of the matrix multiplication, located on the CPU.

    Raises:
        RuntimeError: If either matrix is not on the CPU device.
    """
    ensure_on_cpu(A, "Matrix A")
    ensure_on_cpu(B, "Matrix B")
    return torch.matmul(A, B)

def classical_jacobi(A, max_iterations=100, tol=1e-10):
    """
    Performs the Classical Jacobi method to compute the eigenvalues and eigenvectors
    of a symmetric matrix A using iterative rotations.

    Parameters:
        A (torch.Tensor): A symmetric matrix to decompose, expected to be on the CPU.
        max_iterations (int, optional): The maximum number of iterations to perform. Default is 100.
        tol (float, optional): The tolerance for convergence. Default is 1e-10.

    Returns:
        torch.Tensor: A diagonal matrix containing the eigenvalues of A.
        torch.Tensor: A matrix whose columns are the eigenvectors of A.

    Raises:
        RuntimeError: If the input matrix A is not on the CPU device.
    """
    ensure_on_cpu(A, "Matrix A")
    n = A.shape[0]
    V = torch.eye(n, device=device, dtype=A.dtype)
    for _ in range(max_iterations):
        max_val = 0.0
        p, q = -1, -1
        for i in range(n):
            for j in range(i + 1, n):
                if torch.abs(A[i, j]) > max_val:
                    max_val = torch.abs(A[i, j])
                    p, q = i, j
        if max_val < tol:
            break
        
        theta = 0.5 * torch.atan2(2 * A[p, q], A[q, q] - A[p, p])
        cos_t = torch.cos(theta)
        sin_t = torch.sin(theta)
        
        J = torch.eye(n, device=device, dtype=A.dtype)
        J[p, p] = cos_t
        J[q, q] = cos_t
        J[p, q] = -sin_t
        J[q, p] = sin_t
        
        A = J.T @ A @ J
        V = V @ J
    
    return torch.diag(A), V

def benchmark(matrix_sizes):
    """
    Benchmark the execution time of matrix multiplication and eigenvalue decomposition
    using the Classical Jacobi method on the CPU for various matrix sizes.

    Parameters:
        matrix_sizes (list of int): A list of integers representing the sizes of the
        square matrices to be tested.

    Returns:
        pd.DataFrame: A DataFrame containing the matrix size, time taken for matrix
        multiplication, and time taken for the Classical Jacobi method for each size.
        The results are also saved to a CSV file named 'CPU_SimResults.csv'.
    """
    results = []
    for size in matrix_sizes:
        A = torch.rand((size, size), device=device, dtype=torch.float32)
        B = torch.rand((size, size), device=device, dtype=torch.float32)
        
        start = time.perf_counter()
        C = matrix_multiplication(A, B)
        multiplication_time = time.perf_counter() - start
        
        start = time.perf_counter()
        eigenvalues, eigenvectors = classical_jacobi(C)
        jacobi_time = time.perf_counter() - start
        
        print("Matrix Multiplication Time = ", multiplication_time)
        print("Jacobi Multiplication Time = ", jacobi_time)
        results.append([size, multiplication_time, jacobi_time])
    
    df = pd.DataFrame(results, columns=["Matrix Size", "Multiplication Time (s)", "Jacobi Time (s)"])
    df.to_csv("CPU_SimResults.csv", index=False)
    return df

def fit_curve(x, y):
    """
    Fits a polynomial function to the given data points using non-linear least squares.

    Parameters:
    x (torch.Tensor): The input data points for the independent variable.
    y (torch.Tensor): The input data points for the dependent variable.

    Returns:
    tuple: A tuple containing a lambda function representing the fitted curve and 
           an array of optimized parameters.
    """
    def func(x, *params): return sum(p * x**i for i, p in enumerate(params))
    popt, _ = opt.curve_fit(func, x.cpu().numpy(), y.cpu().numpy(), p0=[1.0] * 4)
    return lambda x: func(x, *popt), popt

def plot_results(df):
    """
    Plots the execution time against matrix sizes and fits a curve to the data.

    Parameters:
    df (pandas.DataFrame): A DataFrame containing 'Matrix Size' and 'Multiplication Time (s)' columns.

    This function uses the `fit_curve` function to fit a polynomial curve to the data points
    and plots both the measured execution times and the fitted curve. The plot displays the
    matrix sizes on the x-axis and the execution times on the y-axis.
    """
    matrix_sizes = torch.tensor(df["Matrix Size"].values, device=device, dtype=torch.float32)
    times = torch.tensor(df["Multiplication Time (s)"].values, device=device, dtype=torch.float32)
    
    #fit_fn, params = fit_curve(matrix_sizes, times)
    #x_fit = torch.linspace(matrix_sizes.min(), matrix_sizes.max(), 100, device=device)
    #y_fit = fit_fn(x_fit)
    
    plt.scatter(matrix_sizes.cpu().numpy(), times.cpu().numpy(), label="Measured Times")
    #plt.plot(x_fit.cpu().numpy(), y_fit.cpu().numpy(), 'r-', label=f"Best Fit: {params}")
    plt.xlabel("Matrix Size")
    plt.ylabel("Execution Time (s)")
    plt.legend()
    plt.show()

if __name__ == "__main__":
    matrix_sizes = [512]
    df = benchmark(matrix_sizes)
    #plot_results(df)