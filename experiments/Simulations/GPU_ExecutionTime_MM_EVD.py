import cupy as cp
import time
import pandas as pd
import scipy.optimize as opt
import matplotlib.pyplot as plt

def matrix_multiplication(A, B):
    """
    Perform matrix multiplication using CuPy.

    Parameters:
        A (cp.ndarray): The first matrix.
        B (cp.ndarray): The second matrix.

    Returns:
        cp.ndarray: The result of multiplying matrix A by matrix B.
    """
    return cp.dot(A, B)

def classical_jacobi(A, max_iterations=100, tol=1e-10):
    """
    Performs the Classical Jacobi algorithm to compute the eigenvalues and eigenvectors
    of a symmetric matrix.

    Parameters:
        A (cp.ndarray): A symmetric matrix for which to compute eigenvalues and eigenvectors.
        max_iterations (int, optional): The maximum number of iterations to perform. Default is 100.
        tol (float, optional): The tolerance level for convergence. Default is 1e-10.

    Returns:
        tuple: A tuple containing:
            - cp.ndarray: A 1D array of eigenvalues.
            - cp.ndarray: A matrix whose columns are the corresponding eigenvectors.
    """
    n = A.shape[0]
    V = cp.eye(n, dtype=A.dtype)
    for _ in range(max_iterations):
        max_val = 0.0
        p, q = -1, -1
        for i in range(n):
            for j in range(i + 1, n):
                if cp.abs(A[i, j]) > max_val:
                    max_val = cp.abs(A[i, j])
                    p, q = i, j
        if max_val < tol:
            break
        
        theta = 0.5 * cp.arctan2(2 * A[p, q], A[q, q] - A[p, p])
        cos_t = cp.cos(theta)
        sin_t = cp.sin(theta)
        
        J = cp.eye(n, dtype=A.dtype)
        J[p, p] = cos_t
        J[q, q] = cos_t
        J[p, q] = -sin_t
        J[q, p] = sin_t
        
        A = J.T @ A @ J
        V = V @ J
    
    return cp.diag(A), V

def benchmark(matrix_sizes):
    """
    Benchmark the execution time of matrix multiplication and the Classical Jacobi algorithm
    for different matrix sizes using CuPy.

    Parameters:
        matrix_sizes (list of int): A list of integers representing the sizes of the matrices
        to be tested.

    Returns:
        pd.DataFrame: A DataFrame containing the matrix size, multiplication time, and Jacobi
        time for each tested size. The results are also saved to a CSV file named
        'GPU_SimResults.csv'.
    """
    results = []
    for size in matrix_sizes:
        A = cp.random.rand(size, size, dtype=cp.float32)
        B = cp.random.rand(size, size, dtype=cp.float32)
        
        start = time.time()
        C = matrix_multiplication(A, B)
        multiplication_time = time.time() - start
        
        start = time.time()
        eigenvalues, eigenvectors = classical_jacobi(C)
        jacobi_time = time.time() - start
        
        results.append([size, multiplication_time, jacobi_time])
    
    df = pd.DataFrame(results, columns=["Matrix Size", "Multiplication Time (s)", "Jacobi Time (s)"])
    df.to_csv("GPU_SimResults.csv", index=False)
    return df

def fit_curve(x, y):
    """
    Fits a cubic polynomial curve to the given data points.

    Parameters:
        x (array-like): The independent variable data.
        y (array-like): The dependent variable data.

    Returns:
        function: A lambda function representing the fitted cubic polynomial.
        array: The optimal values for the polynomial coefficients.
    """
    def poly3(x, a, b, c, d): return a*x**3 + b*x**2 + c*x + d
    popt, _ = opt.curve_fit(poly3, x, y)
    return lambda x: poly3(x, *popt), popt

def plot_results(df):
    """
    Plots the execution time results for matrix multiplication.

    This function takes a DataFrame containing matrix sizes and their corresponding
    multiplication times, fits a cubic polynomial to the data, and plots both the
    measured times and the fitted curve.

    Parameters:
        df (pandas.DataFrame): A DataFrame with columns "Matrix Size" and 
        "Multiplication Time (s)" representing the data to be plotted.

    Returns:
        None
    """
    matrix_sizes = df["Matrix Size"].values
    times = df["Multiplication Time (s)"].values
    
    fit_fn, params = fit_curve(matrix_sizes, times)
    x_fit = cp.linspace(min(matrix_sizes), max(matrix_sizes), 100)
    y_fit = fit_fn(x_fit)
    
    plt.scatter(matrix_sizes, times, label="Measured Times")
    plt.plot(x_fit.get(), y_fit.get(), 'r-', label=f"Best Fit: {params}")
    plt.xlabel("Matrix Size")
    plt.ylabel("Execution Time (s)")
    plt.legend()
    plt.show()

if __name__ == "__main__":
    matrix_sizes = [64, 128, 256, 512]
    df = benchmark(matrix_sizes)
    plot_results(df)
