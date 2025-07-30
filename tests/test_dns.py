import dns.message
import dns.query
import dns.flags
import dns.rdatatype
import pytest

dns_base_ip = "127.0.0.1"
dns_base_port = 5335

def query_dns_over_udp(domain, record_type, ip, port):
    query = dns.message.make_query(domain, record_type, want_dnssec=True)
    try:
        response = dns.query.udp(query, ip, port=port, timeout=2)
        return response
    except Exception as e:
        pytest.fail(f"DNS query to {ip}:{port} failed: {e}")

def test_dns_resolver_on_custom_port():
    domain = "google.com"
    record_type = "A"

    response = query_dns_over_udp(domain, record_type, dns_base_ip, dns_base_port)

    answers = [rr.to_text() for rrset in response.answer for rr in rrset]
    assert answers, f"No {record_type} records found for {domain}"
    ad_flag = bool(response.flags & dns.flags.AD)
    print("AD flag set:", ad_flag)

def test_dnssec():
    domain = "dnssec-failed.org"
    record_type = "A"

    response = query_dns_over_udp(domain, record_type, dns_base_ip, dns_base_port)

    assert response.rcode() == 2, f"The {domain} was resolved by {dns_base_ip}:{dns_base_port}"

