import unittest
import numpy as np

from .base_test import BaseTestCase

# from package_name.module import cubic_rectification
from ..module import cubic_rectification


class TestCubicRectification(BaseTestCase):

    def test_scalar(self):
        self.assertEqual(8, cubic_rectification(2))
        self.assertEqual(0, cubic_rectification(-2))
        self.assertEqual(27, cubic_rectification(3))

    def test_array(self):
        self.assert_equal(np.array(27), cubic_rectification(np.array(3)))
        self.assert_equal(np.array([0, 8, 0]),
                          cubic_rectification(np.array([0, 2, -2])))

    @unittest.expectedFailure
    def test_skip_success(self):
        self.assert_equal(float('nan'), (float('nan')))
