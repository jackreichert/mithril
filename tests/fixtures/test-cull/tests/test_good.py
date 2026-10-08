from src.calc import add


def test_add_returns_sum():
    assert add(2, 3) == 5


def test_add_handles_negatives():
    assert add(-2, -3) == -5
