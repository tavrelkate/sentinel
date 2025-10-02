
# Sentinel 🔒

> A Ruby/Rails library for scrubbing and masking sensitive data (PII, PCI, HIPAA, secrets, infra) in logs, models, and applications.

---

## ✨ Features

- Mask sensitive data such as emails, SSNs, tokens, credit cards, IP addresses, and more
- Supports modular **policies** (`:pii`, `:pci`, `:hipaa`, `:infra`, `:secrets`)
- Pluggable **masking modes**: `:full`, `:partial`, `:hash`
- Clean Ruby API (`Sentinel::Data.new(data)`)

---

## 🚀 Installation

Add to your `Gemfile`:

```ruby
gem "sentinel"
```

Then install:
```bash
bundle install
```


## ⚙️ Configuration

Configure once, usually in config/initializers/sentinel.rb:

```ruby
Sentinel.configure do |c|
  c.policy :pii
end
```


## ⚡ Policies

Sentinel supports modular policies for compliance domains:

```ruby

Sentinel.configure do |c|
  c.policy :pii
end
```

Available built-in policies:

- :pii – emails, phones, addresses, SSNs
- :pci – credit cards, CVV
- :hipaa – patient IDs, diagnoses
- :infra – IPs, MAC addresses, hostnames
- :secrets – tokens, keys, passwords


### 📦 Custom Policies

You can define your own policy:
```ruby
Sentinel::Policy.define :my_app do
  label "My App Sensetive Data Policy"
  keywords "api_key", "auth_token"
  regexes  /\b\d{16}\b/ # credit card numbers
end

Sentinel.configure do |c|
  c.policy :my_app
end
```

## 🔑 Masking Strategies

- Full — everything is replaced with [FILTERED]
- Partial — part of the value is preserved
- Hash — replaced with SHA256 hash


## Authors

- [Valeriya Petrova](https://github.com/piatrova-valeriya1999)
- [Tavrel Kate](https://github.com/tavrelkate)
