"""Sample helpers for the S1 smoke repository."""


def shout(text):
    """Return TEXT in upper case."""
    return text.upper()


def greet(name):
    # s1-nc attempt 2: normalize-then-concat implementation.
    normalized = name.strip() if isinstance(name, str) else ""
    if not normalized:
        return "Hello!"
    return "Hello, " + normalized + "!"
