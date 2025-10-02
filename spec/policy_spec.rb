# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sentinel::Policy do
  let(:valid_keywords) { %w[email phone] }
  let(:valid_regexes)  { [/abc/, /123/] }

  describe ".new" do
    context "with valid attributes" do
      it "creates a policy" do
        policy = described_class.new(
          name: :pii,
          keywords: valid_keywords,
          regexes: valid_regexes,
          label: "PII Data"
        )

        expect(policy.name).to eq(:pii)
        expect(policy.keywords).to eq(%w[email phone])
        expect(policy.regexes).to all(be_a(Regexp))
        expect(policy.label).to eq("PII Data")
      end
    end

    shared_examples "invalid attribute" do |attr, invalid_value, error_match|
      it "raises for invalid #{attr}" do
        args = { name: :pii, keywords: [], regexes: [], label: "ok" }
        args[attr] = invalid_value

        expect {
          described_class.new(**args)
        }.to raise_error(ArgumentError, error_match)
      end
    end

    describe "invalid name" do
      include_examples "invalid attribute", :name, nil, /invalid name/
      include_examples "invalid attribute", :name, 123, /invalid name/
    end

    describe "invalid keywords" do
      include_examples "invalid attribute", :keywords, "not Array", /invalid keyword/
    end

    describe "invalid regexes" do
      include_examples "invalid attribute", :regexes, "not Array", /invalid regex/
    end

    describe "invalid label" do
      include_examples "invalid attribute", :label, 123, /invalid label/
    end
  end
end
