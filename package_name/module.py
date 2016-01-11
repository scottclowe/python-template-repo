import numpy as np


def cubic_rectification(x):
    '''
    Returns the rectified value of the cube of X.
    If X is positive, this is the cube of X, if X is negative it is 0.
    '''
    return np.maximum(0, x**3)
