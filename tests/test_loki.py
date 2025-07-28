import re
import requests
import pytest

loki_base_url = "http://localhost:3100"

def get_loki(target):
    try:
        return requests.get(f"{ loki_base_url }{ target }")
    except requests.exceptions.RequestException as e:
        assert False, f"Failed to connect to Loki: {e}"

def test_loki_wrong_url():
    response = get_loki("/wrong/url")
    assert response.status_code == 404

def test_loki_status():
    response = get_loki("/loki/api/v1/series")
    assert response.status_code == 200, f"Unexpected status: {response.status_code}"
    assert "application/json" in response.headers.get("Content-Type", ""), "Expected JSON response"
    status = response.json().get("status")
    assert status == "success"

def test_loki_data_source():
    response = get_loki("/loki/api/v1/series")
    assert response.status_code == 200, f"Unexpected status: {response.status_code}"
    assert "application/json" in response.headers.get("Content-Type", ""), "Expected JSON response"
    data = response.json().get("data")
    jobs = [data_source.get("job") for data_source in data]
    assert "unbound-dns" in jobs, f"'unbound-dns' job not found in {jobs}"
