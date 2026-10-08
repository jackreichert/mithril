from src.calc import normalize


def test_a():
    assert normalize("  Ada ") == "expected-value-ada"


def test_b():
    assert normalize("  Ada ") == "expected-value-ada"


def test_c():
    assert normalize("  Ada ") == "expected-value-ada"
