import unittest

import sample


def has_greet():
    return callable(getattr(sample, "greet", None))


class TestSample(unittest.TestCase):
    def test_shout(self):
        self.assertEqual(sample.shout("hi"), "HI")

    @unittest.skipUnless(has_greet(), "greet not implemented yet")
    def test_greet_name(self):
        self.assertEqual(sample.greet("World"), "Hello, World!")

    @unittest.skipUnless(has_greet(), "greet not implemented yet")
    def test_greet_trims(self):
        self.assertEqual(sample.greet("  Ada  "), "Hello, Ada!")

    @unittest.skipUnless(has_greet(), "greet not implemented yet")
    def test_greet_empty(self):
        self.assertEqual(sample.greet(""), "Hello!")
        self.assertEqual(sample.greet("   "), "Hello!")


if __name__ == "__main__":
    unittest.main()
