"""Sample helpers for the S1 smoke repository."""


def shout(text):
    """Return TEXT in upper case."""
    return text.upper()


def greet(name):
    """Return a greeting for NAME, defaulting to a bare 'Hello!'.

    Empty, whitespace-only, and None callers all produce 'Hello!'.
    """
    if name is None:
        return "Hello!"
    if not name or not name.strip():
        return "Hello!"
    return f"Hello, {name.strip()}!"
