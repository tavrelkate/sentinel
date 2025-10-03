# lib/sentinel/patterns.rb
# frozen_string_literal: true
require "resolv"

module Sentinel
  module Patterns
    EMAIL = /\b\w([\w+.-]|%2B)+(?:@|%40)[a-z\d-]+(?:\.[a-z\d-]+)*\.[a-z]+\b/i

    # US-like (###) ###-#### with optional country code
    PHONE      = /\b(?:\+\d{1,2}\s)?\(?\d{3}\)?[\s+.-]\d{3}[\s+.-]\d{4}\b/
    # E.164 (international, +XXXXXXXX)
    E164_PHONE = /(?:\+|%2B)[1-9]\d{6,14}\b/

    # US Social Security Number
    SSN = /\b(?!000|666|9\d{2})[0-8]\d{2}[\s+-](?!00)\d{2}[\s+-](?!0000)\d{4}\b/
    # Field name detector (keys like first_name / last_name)
    NAME_FIELD = /\b(?:first|last)[\s_]?name\b/i
    # Vehicle Identification Number (VIN)
    VIN = /\b([A-HJ-NPR-Z0-9]{17})\b/

    # Generic PAN (13–19 digits, optional separators) — validate with Luhn in code if needed
    PAN_GENERIC = /\b(?:\d[ -]?){13,19}\b/
    # Compact 16-digit (Visa/Mastercard etc.); does NOT include Amex (15)
    CREDIT_CARD = /\b[3456]\d{15}\b/
    # 16-digit grouped (#### #### #### #### or with -/+)
    CREDIT_CARD_DELIMITED = /\b[3456]\d{3}[\s+-]\d{4}[\s+-]\d{4}[\s+-]\d{4}\b/
    # CVV/CVC/CID (very broad — expect false positives; use with key context)
    CVV = /\b\d{3,4}\b/
    # Expiry (MM/YY or MM/YYYY)
    EXPIRY = /\b(0[1-9]|1[0-2])\/?([0-9]{2}|20[0-9]{2})\b/

    BEARER_TOKEN      = /Bearer\s+([a-zA-Z0-9\-_]{20,})/i
    JWT               = /(?<!\S)eyJ[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*\.[A-Za-z0-9_-]*(?!\S)/
    AWS_ACCESS_KEY_ID = /\bAKIA[0-9A-Z]{16}\b/
    PEM_PRIVATE_KEY   = %r{-----BEGIN (?:RSA|EC|DSA|OPENSSH) PRIVATE KEY-----}

    IPV4   = Resolv::IPv4::Regex
    IPV6   = Resolv::IPv6::Regex
    IP_ANY = /\b(?:(?:\d{1,3}\.){3}\d{1,3})\b|(?:[a-fA-F0-9]{1,4}:){2,7}[a-fA-F0-9]{1,4}/
    MAC_ADDRESS = /\b(?:[0-9A-Fa-f]{2}[:-]){5}[0-9A-Fa-f]{2}\b/
    URL = %r{\bhttps?://[^\s]+\b}i

    UUID     = /\b[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}\b/i
    US_ZIP   = /\b\d{5}(?:-\d{4})?\b/
    DATE_ISO = /\b\d{4}-\d{2}-\d{2}\b/
    DATE_US  = /\b\d{2}\/\d{2}\/\d{4}\b/
  end
end
