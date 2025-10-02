# frozen_string_literal: true
require "resolv"

module Sentinel
  module Patterns
    # Emails
    EMAIL       = /\b\w([\w+.-]|%2B)+(?:@|%40)[a-z\d-]+(?:\.[a-z\d-]+)*\.[a-z]+\b/i

    # Phones
    PHONE       = /\b(?:\+\d{1,2}\s)?\(?\d{3}\)?[\s+.-]\d{3}[\s+.-]\d{4}\b/
    E164_PHONE  = /(?:\+|%2B)[1-9]\d{6,14}\b/

    # SSN (US Social Security Number)
    SSN         = /\b(?!000|666|9\d{2})[0-8]\d{2}[\s+-](?!00)\d{2}[\s+-](?!0000)\d{4}\b/

    # Credit cards
    CREDIT_CARD            = /\b[3456]\d{15}\b/
    CREDIT_CARD_DELIMITED  = /\b[3456]\d{3}[\s+-]\d{4}[\s+-]\d{4}[\s+-]\d{4}\b/
    CVV                    = /\b\d{3,4}\b/

    # Secrets / tokens
    BEARER_TOKEN = /Bearer\s+([a-zA-Z0-9\-_]{20,})/i
    JWT          = /(?<!\S)eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*(?!\S)/

    # IP addresses
    IPV6   = Resolv::IPv6::Regex
    IPV4   = Resolv::IPv4::Regex
    IP_ANY = /\b(?:(?:\d{1,3}\.){3}\d{1,3})\b|(?:[a-fA-F0-9]{1,4}:){7}[a-fA-F0-9]{1,4}/

    # Vehicle Identification Number
    VIN = /\b([A-HJ-NPR-Z0-9]{17})\b/

    # Names
    NAME = /\b(?:first|last)[\s_]?name\b/i
  end
end
