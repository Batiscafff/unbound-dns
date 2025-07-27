import re
import requests
import pytest

promtail_base_url = "http://localhost:9080"

def get_promtail(target):
    try:
        return requests.get(f"{ promtail_base_url }{ target }")
    except requests.exceptions.RequestException as e:
        assert False, f"Failed to connect to Promtail: {e}"

def test_promtail_wrong_url():
    response = get_promtail("/wrong/url")
    assert response.status_code == 404

def test_promtail_status():
    response = get_promtail("/ready")
    assert response.status_code == 200

def test_promtail_job():
    response = get_promtail("/targets")
    assert re.findall(r"unbound-dns\s+\(\d+/\d+\s+ready\)", response.text, flags=re.MULTILINE)
