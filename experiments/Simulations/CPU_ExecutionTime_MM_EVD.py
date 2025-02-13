import numpy as np
import time
import matplotlib.pyplot as plt
import pandas as pd
from scipy.optimize import curve_fit
from sympy import symbols, lambdify
from sklearn.metrics import mean_squared_error

def linear_function(x, a, b):
    """
    Calculate the value of a linear function.

    Parameters:
    x : float or array-like
        The independent variable(s).
    a : float
        The slope of the line.
    b : float
        The y-intercept of the line.

    Returns:
    float or array-like
        The computed value(s) of the linear function.
    """
    return a * x + b

def polynomial_function(x, a, b, c):
    """
    Calculate the value of a quadratic polynomial function.

    Parameters:
        x (float): The input value for the polynomial.
        a (float): The coefficient of the quadratic term.
        b (float): The coefficient of the linear term.
        c (float): The constant term.

    Returns:
        float: The result of the polynomial a*x^2 + b*x + c.
    """
    return a * x**2 + b * x + c

def exponential_function(x, a, b, c):
    """
    Calculate the value of an exponential function.

    Parameters:
        x (float or np.ndarray): The input value(s) for the function.
        a (float): The coefficient that scales the exponential term.
        b (float): The exponent coefficient.
        c (float): The constant term added to the exponential result.

    Returns:
        float or np.ndarray: The result of the exponential function for the given input.
    """
    return a * np.exp(b * x) + c

def logarithmic_function(x, a, b):
    """
    Calculate a logarithmic function.

    Parameters:
        x (float or np.ndarray): The input value(s) for which the logarithmic function is evaluated.
        a (float): The coefficient for the logarithmic term.
        b (float): The constant term added to the logarithmic result.

    Returns:
        float or np.ndarray: The result of the logarithmic function a * log(x) + b.
    """
    return a * np.log(x) + b

def power_function(x, a, b):
    """
    Calculate the power of a given base.

    Parameters:
        x (float): The base value.
        a (float): The coefficient.
        b (float): The exponent.

    Returns:
        float: The result of a * x raised to the power of b.
    """
    return a * x**b

def perform_curve_fitting(df, x_col, y_col):
    """
    Perform curve fitting on a dataset to find the best fitting model.

    This function takes a DataFrame and the names of the columns representing
    the independent and dependent variables. It attempts to fit several models
    (linear, polynomial, exponential, logarithmic, and power) to the data and
    selects the model with the lowest mean squared error. The function returns
    the name and parameters of the best fitting model and plots the data along
    with the best fit curve.

    Parameters:
        df (pd.DataFrame): The DataFrame containing the data.
        x_col (str): The name of the column representing the independent variable.
        y_col (str): The name of the column representing the dependent variable.

    Returns:
        tuple: A tuple containing the name of the best fitting model and its parameters.
    """
    X = df[x_col].values
    Y = df[y_col].values
    
    models = {
        "Linear": (linear_function, [1, 1]),
        "Polynomial": (polynomial_function, [1, 1, 1]),
        "Exponential": (exponential_function, [1, 0.01, 1]),
        "Logarithmic": (logarithmic_function, [1, 1]),
        "Power": (power_function, [1, 1])
    }
    
    best_fit = None
    best_error = float('inf')
    best_params = None
    best_model_name = None
    
    for model_name, (model_func, initial_params) in models.items():
        try:
            popt, _ = curve_fit(model_func, X, Y, p0=initial_params)
            Y_pred = model_func(X, *popt)
            error = mean_squared_error(Y, Y_pred)
            
            if error < best_error:
                best_error = error
                best_fit = model_func
                best_params = popt
                best_model_name = model_name
        except Exception:
            continue
    
    if best_fit is None:
        print("Curve fitting failed. Ensure your data is suitable for fitting.")
        return None
    
    print(f"Best fit model: {best_model_name}")
    print(f"Best fit parameters: {best_params}")
    
    x_sym = symbols('x')
    fitted_eqn = best_fit(x_sym, *best_params)
    print(f"Fitted equation: y = {fitted_eqn}")
    
    plt.figure(figsize=(8, 5))
    plt.scatter(X, Y, label='Data Points', color='red')
    X_fit = np.linspace(min(X), max(X), 100)
    Y_fit = best_fit(X_fit, *best_params)
    plt.plot(X_fit, Y_fit, label=f'Best Fit: {best_model_name}', color='blue')
    plt.xlabel(x_col)
    plt.ylabel(y_col)
    plt.title('Best Curve Fit Selection')
    plt.legend()
    plt.grid()
    plt.show()
    
    return best_model_name, best_params

def matrix_multiplication(A, B):
    """
    Perform matrix multiplication on two input matrices.

    Parameters:
        A (array-like): The first matrix.
        B (array-like): The second matrix.

    Returns:
        ndarray: The result of multiplying matrix A by matrix B.
    """
    return np.dot(A, B)

def classical_jacobian(A, tol=1e-6, max_iter=100):
    """
    Performs the Classical Jacobi method for eigenvalue decomposition.

    This function iteratively applies the Jacobi rotation to a symmetric matrix
    to find its eigenvalues and eigenvectors. The process continues until the 
    off-diagonal elements are below a specified tolerance or a maximum number 
    of iterations is reached.

    Parameters:
        A (np.ndarray): A symmetric matrix for which eigenvalues and eigenvectors 
                        are to be computed.
        tol (float, optional): The tolerance level for convergence. Defaults to 1e-6.
        max_iter (int, optional): The maximum number of iterations allowed. Defaults to 100.

    Returns:
        np.ndarray: A 1D array containing the eigenvalues of the matrix.
        np.ndarray: A matrix whose columns are the normalized eigenvectors 
                    corresponding to the eigenvalues.
    """
    n = A.shape[0]
    V = np.eye(n)
    for _ in range(max_iter):
        max_val = 0
        p, q = 0, 1
        for i in range(n):
            for j in range(i + 1, n):
                if abs(A[i, j]) > max_val:
                    max_val = abs(A[i, j])
                    p, q = i, j
        
        if max_val < tol:
            break
        
        phi = 0.5 * np.arctan2(2 * A[p, q], A[q, q] - A[p, p])
        c, s = np.cos(phi), np.sin(phi)
        
        J = np.eye(n)
        J[p, p] = c
        J[q, q] = c
        J[p, q] = s
        J[q, p] = -s
        
        A = J.T @ A @ J
        V = V @ J
    
    return np.diag(A), V

def benchmark(matrix_sizes):
    """
    Benchmarks the execution time of matrix operations for varying matrix sizes.

    This function generates random matrices of specified sizes, performs matrix 
    multiplication and eigenvalue decomposition using the Classical Jacobi method, 
    and records the execution time for each operation. The results are saved to a 
    CSV file and returned as a DataFrame.

    Parameters:
        matrix_sizes (list of int): A list of integers representing the sizes of 
                                    the matrices to be tested.

    Returns:
        pd.DataFrame: A DataFrame containing the matrix size, time taken for matrix 
                    multiplication, time taken for the Jacobi method, and the 
                    total execution time for each matrix size.
    """
    results = []
    
    for size in matrix_sizes:
        A = np.random.rand(size, size)
        B = np.random.rand(size, size)
        
        start = time.time()
        _ = matrix_multiplication(A, B)
        end = time.time()
        time_mm = end - start
        
        #A_symm = 0.5 * (A + A.T)  # Make A symmetric for Jacobi
        start = time.time()
        __ = classical_jacobian(_)
        end = time.time()
        time_jacobi = end - start
        
        total_time = time_mm + time_jacobi
        results.append([size, time_mm, time_jacobi, total_time])
    
    df = pd.DataFrame(results, columns=['Matrix Size', 'Matrix Multiplication Time', 'Jacobian Time', 'Total Execution Time'])
    df.to_csv("AMD_SimResults.csv", header=True, index=True)
    return df

def plot_results(df):
    """
    Plots the execution time results for matrix operations.

    This function generates a plot displaying the total execution time
    against matrix size, using data from the provided DataFrame. The plot
    includes labels for the axes, a title, a legend, and a grid for better
    visualization.

    Parameters:
        df (pandas.DataFrame): A DataFrame containing 'Matrix Size' and
        'Total Execution Time' columns.

    Returns:
        None
    """
    plt.figure(figsize=(8, 5))
    plt.plot(df['Matrix Size'], df['Total Execution Time'], label='Total Execution Time', marker='o')
    plt.xlabel('Matrix Dimension')
    plt.ylabel('Execution Time (seconds)')
    plt.title('CPU Performance: Matrix Multiplication + Classical Jacobian')
    plt.legend()
    plt.grid()
    plt.show()

if __name__ == "__main__":
    matrix_sizes = [4, 8, 16, 32, 64, 128, 256, 512, 1024]      # Dimensions of matrices
    df_results = benchmark(matrix_sizes)                        # Run benchmarking and obtain results
    print(df_results)
    perform_curve_fitting(df_results, 'Matrix Size', 'Total Execution Time')    # Perform curve fitting to obtain equation
    plot_results(df_results)
