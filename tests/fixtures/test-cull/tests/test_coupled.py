from src import calc


def test_add_calls_internal_helper_once():
    assert calc._calls == 1
