"""
Module provides a simple cubic_rectification function.
"""

import numpy as np


def cubic_rectification(x):
    """
    Rectified cube of an array.

    Parameters
    ----------
    X : numpy.ndarray
        Input array.

    Returns
    -------
    numpy.ndarray
        Elementwise, the cube of `X` where it is positive and `0` otherwise.

    Note
    ----
    This is a sample function, using a Google docstring format.

    Note
    ----
    The use of intersphinx will cause numpy.ndarray above to link to its
    documentation, but not inside this Note.
    """
    return np.maximum(0, x ** 3)
