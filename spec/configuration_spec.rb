# frozen_string_literal: true

require "spec_helper"

RSpec.describe Sentinel::Configuration do
  subject(:config) { described_class.new }

  describe "#policy=" do
    before do
      Sentinel::Policy.describe :pii do
        keywords "email"
        regexes /\b.+@.+\b/
      end
    end

    it "assigns a policy by name" do
      config.policy = :pii
      expect(config.policy).to be_a(Sentinel::Policy)
      expect(config.policy.name).to eq(:pii)
    end
  end
end
