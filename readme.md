
# Sentinel 🔒

> A Ruby/Rails library for **scrubbing and masking sensitive data** (PII, PCI, HIPAA, secrets, infra) in logs, models, and app payloads.

<p align="center">
  <img alt="Ruby" src="https://www.ruby-lang.org/images/header-ruby-logo.png" height="44" />
  &nbsp;&nbsp;&nbsp;&nbsp;
  <img alt="Ruby on Rails" src="https://raw.githubusercontent.com/rails/website/main/assets/images/logo.svg" height="44" />
</p>

<p align="center">
  <a href="#"><img alt="Gem Version" src="https://img.shields.io/badge/gem-sentinel-informational"></a>
  <a href="#"><img alt="Build Status" src="https://img.shields.io/badge/build-passing-success"></a>
  <a href="#"><img alt="License" src="https://img.shields.io/badge/license-MIT-blue"></a>
  <img alt="Ruby badge" src="https://img.shields.io/badge/Ruby-3.3%2B-CC342D?logo=ruby&logoColor=white" />
  <img alt="Rails badge" src="https://img.shields.io/badge/Rails-7.x-CC0000?logo=rubyonrails&logoColor=white" />
</p>

---

## Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Rails Integration](#-rails-integration)
- [Configuration](#-configuration)
- [Policies](#-policies)
  - [Custom Policies](#-custom-policies)
- [Masking Strategies](#-masking-strategies)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [Authors](#-authors)
- [License](#-license)

---

## ✨ Features

- Masks common sensitive fields: emails, SSNs, tokens, credit cards, IPs, and more
- Modular **policies** you can enable/disable (`:pii`, `:pci`, `:hipaa`, `:gdpr`, `:infra`, `:secrets`)
- Pluggable **masking modes**: `:full`, `:partial`, `:hash`
- Clean, minimal API (`Sentinel::Data.new(data)`)
- **Rails formatter** for safe application logs

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

---

## <img alt="Ruby" src="https://www.ruby-lang.org/images/header-ruby-logo.png" height="20" /> Quick Ruby Start
Create a simple initializer (e.g. `config/initializers/sentinel.rb`):

```ruby
Sentinel.configure do |c|
  c.policy = :pii
  # c.mask = Sentinel::Mask.new(:full, "[FILTERED]") # optional; see strategies below
end
```

Mask a payload:

```ruby
data = { email: "user@example.com" }

Sentinel::Data.new(data)
#=> { email: "[FILTERED]" }
```

---

##  <img alt="Ruby on Rails" src="https://raw.githubusercontent.com/rails/website/main/assets/images/logo.svg" height="20" /> Rails Integration
There are **two ways** to enable masked logging in Rails.

### Option 1 — Quick (via Railtie)

Sentinel provides a Railtie that installs a log formatter which masks sensitive values.

**Enable/disable**
```ruby
# config/environments/development.rb (or any env)
Rails.application.configure do
  config.sentinel.enable_log_formatter = true  # set to false to disable
end
```

**Pick formatter class (optional)**
```ruby
# config/environments/development.rb
Rails.application.configure do
  config.sentinel.formatter_class = Sentinel::Plugins::Rails::LogFormatter
end
```

**Result**
Any Rails log line will be scrubbed, e.g.:
```ruby
Rails.logger.info(email: "user@example.com", ok: true)
# => {"email":"[FILTERED]","ok":true}
```

---

### Option 2 — Manual (no Railtie)

Set the formatter yourself in an environment file or initializer.

```ruby
# config/environments/development.rb
Rails.application.configure do
  formatter = Sentinel::Plugins::Rails::LogFormatter.new

  base = ActiveSupport::Logger.new($stdout) # or a file
  base.level = Logger::DEBUG
  base.formatter = formatter

  config.logger = ActiveSupport::TaggedLogging.new(base)
  config.log_formatter = formatter
end
```

**Result**
```ruby
Rails.logger.info(email: "user@example.com", ok: true)
# => {"email":"[FILTERED]","ok":true}
```

---

## ⚙️ Configuration

Configure once, usually in `config/initializers/sentinel.rb`:

```ruby
Sentinel.configure do |c|
  c.policy = :pii
  c.mask   = Sentinel::Mask.new(:partial, "***")
end
```

> Tip: Policies determine **what** gets masked; Masks determine **how** it looks.

---

## 📜 Policies

Policies define **what** gets masked.

Enable PII protection:

```ruby
Sentinel.configure do |c|
  c.policy = :pii
end
```

List all available policies:

```ruby
Sentinel::Policy.all
```

Example output:

```ruby
# :pii=>#<Sentinel::Policy name=:pii label="Personally Identifiable Information (PII)" keywords=7 regexes=5>,
# :pci=>#<Sentinel::Policy name=:pci label="Payment Card Industry (PCI)" keywords=3 regexes=3>,
# :hipaa=>#<Sentinel::Policy name=:hipaa label="Health Insurance Portability and Accountability Act (HIPAA)" keywords=3 regexes=1>,
# :gdpr=>#<Sentinel::Policy name=:gdpr label="General Data Protection Regulation (GDPR)" keywords=4 regexes=4>,
# :infra=>#<Sentinel::Policy name=:infra label="Infrastructure secrets & identifiers" keywords=8 regexes=5>,
# :secrets=>#<Sentinel::Policy name=:secrets label="Application Secrets" keywords=... regexes=...>
```

Peek into a policy:

```ruby
Sentinel::Policy.all[:pii].keywords
#=> ["user", "client", "card", "phone", "email", "address", "ssn"]

Sentinel::Policy.all[:pii].regexes
#=> [/\b\w+.../, /\b(?:\+\d{1,2}\s)?\(?\d{3}\).../, ...]
```

### 🧩 Custom Policies

Describe your own policy with a DSL:

```ruby
Sentinel::Policy.describe :checkout_pci_strict do
  label   "Checkout PCI (Strict)"
  keywords "card_number", "cvv", "expiry", "name_on_card"
  regexes  %r{\b(?:\d[ -]?){16}\b}
end

Sentinel.configure do |c|
  c.policy = :checkout_pci_strict
end
```

---

## 🔑 Masking Strategies

Strategies define **how** values are transformed.

### 1) Full — replace the entire value

```ruby
Sentinel.configure do |c|
  c.mask = Sentinel::Mask.new(:full, "[FILTERED]")
end

Sentinel::Data.new(email: "user@example.com")
#=> { email: "[FILTERED]" }
```

### 2) Partial — preserve a small, non-sensitive slice

```ruby
Sentinel.configure do |c|
  c.mask = Sentinel::Mask.new(:partial, "***")
end

Sentinel::Data.new(email: "user@example.com")
#=> { email: "us***om" }
```

### 3) Hash — replace with a deterministic SHA-256 hash

```ruby
Sentinel.configure do |c|
  c.mask = Sentinel::Mask.new(:hash, :sha256)
end

Sentinel::Data.new(email: "user@example.com")
#=> { email: "b4c9a289323b21a01c3e940f150eb9b8c542587f1abfd8f0e1cc1ffc5e475514" }
```

---

## 🛠 Troubleshooting

- **“It didn’t mask a field I expected.”**
  - Check the active policy (`Sentinel::Policy.all[...]`) and its `keywords`/`regexes`.
  - Add a custom policy or extend an existing one.

- **“The mask output looks odd.”**
  - Confirm your configured mask strategy and placeholder (e.g., `"[FILTERED]"` vs `"***"`).

- **“I need to keep some signal.”**
  - Use `:partial` or `:hash` instead of `:full`.

---

## 🤝 Contributing

Bug reports and pull requests are welcome! Please:
1. Open an issue describing the problem or proposal.
2. Include minimal repro steps or failing tests where possible.

---

## 👩‍💻 Authors

- [Valeriya Petrova](https://github.com/piatrova-valeriya1999)
- [Tavrel Kate](https://github.com/tavrelkate)

---

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
