# frozen_string_literal: true

require_relative "patterns"
require_relative "../core/policy"

Sentinel::Policy.describe :pii do
  label "Personally Identifiable Information (PII)"
  keywords "user", "client", "card", "phone", "email", "address", "ssn"
  regexes  Sentinel::Patterns::EMAIL,
           Sentinel::Patterns::PHONE,
           Sentinel::Patterns::E164_PHONE,
           Sentinel::Patterns::SSN,
           Sentinel::Patterns::NAME
end

Sentinel::Policy.describe :pci do
  label "Payment Card Industry (PCI)"
  keywords "card", "cvv", "pan"
  regexes  Sentinel::Patterns::CREDIT_CARD,
           Sentinel::Patterns::CREDIT_CARD_DELIMITED,
           Sentinel::Patterns::CVV
end

Sentinel::Policy.describe :hipaa do
  label "Health Insurance Portability and Accountability Act (HIPAA)"
  keywords "patient", "diagnosis", "mrn"
  regexes  /\b[A-Z]{2}\d{6}\b/
end

Sentinel::Policy.describe :gdpr do
  label "General Data Protection Regulation (GDPR)"
  keywords "ip", "cookie", "email", "address"
  regexes  Sentinel::Patterns::EMAIL,
           Sentinel::Patterns::IPV4,
           Sentinel::Patterns::IPV6,
           Sentinel::Patterns::IP_ANY
end

Sentinel::Policy.describe :infra do
  label "Infrastructure secrets & identifiers"
  keywords "hostname", "fqdn", "mac", "secret", "token", "auth", "jwt", "session"
  regexes  Sentinel::Patterns::BEARER_TOKEN,
           Sentinel::Patterns::JWT,
           Sentinel::Patterns::IPV4,
           Sentinel::Patterns::IPV6,
           Sentinel::Patterns::IP_ANY
end
