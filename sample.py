"""Sample helpers for the S1 smoke repository."""


def shout(text):
    """Return TEXT in upper case."""
    return text.upper()


def greet(name):
    # s1-nc attempt 1: trim-and-format implementation.
    if not name or not name.strip():
        return "Hello!"
    return f"Hello, {name.strip()}!"
