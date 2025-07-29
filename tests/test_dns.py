import dns.resolver
import dns.flags
import pytest

dns_base_ip = "127.0.0.1"

def query_custom_dns(domain, record_type, custom_dns_ip):
    resolver = dns.resolver.Resolver()
    resolver.nameservers = [custom_dns_ip]
    try:
        answers = resolver.resolve(domain, record_type)
        return answers
    except dns.resolver.NoAnswer:
        assert False, f"No {record_type} record found for {domain} on {custom_dns_ip}"
    except Exception as e:
        assert False, f"Error querying {record_type} record for {domain}: {e}"

def test_dns_resolver():
    record_type_to_query = "A"
    domain_to_query = "google.com"
    results = query_custom_dns(domain_to_query, record_type_to_query, dns_base_ip)
    if results:
        for rdata in results:
            assert rdata.to_text(), f"The answer cannot be recognized"

