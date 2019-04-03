require 'rails_helper'

RSpec.describe Url, type: :model do

  let(:subject) {
    Url.new({
      url: "http://www.example.com",
      shortcode: "a2B3kj",
      })
  }
  describe "validations" do
    it "is valid with valid properties" do
      expect(subject).to be_valid
    end

    it "is invalid without a url" do
      subject.url = nil
      expect(subject).not_to be_valid
    end

    it "is invalid without a url protocol" do
      subject.tests_action = true
      subject.url = "www.example.com"
      expect(subject).not_to be_valid
    end

    it "is invalid without a shortcode" do
      subject.tests_action = true # don't run generate_shortcode
      subject.shortcode = nil
      expect(subject).not_to be_valid
    end

    it "is invalid with an invalid shortcode" do
      subject.shortcode = "34 jjK"
      expect(subject).not_to be_valid
    end

    it "is invalid with a shortcode of the wrong length" do
      subject.shortcode = "jsidofijsodjifos"
      expect(subject).not_to be_valid
    end
  end

  describe "methods" do
    it "generates a shortcode of length 6" do
      subject.shortcode = nil
      subject.generate_shortcode
      expect(subject.shortcode).not_to be_nil
      expect(subject.shortcode.length).to eq(6)
    end

    it "increments its usage count" do
      subject.save
      expect(subject.usage_count).to eq(0)
      expect(subject.last_usage).to be_nil
      subject.record_usage
      expect(subject.usage_count).to eq(1)
      expect(subject.last_usage).not_to be_nil
    end

    it "adds http:// to url if not present" do
      subject.url = "www.example.com"
      subject.validate
      expect(subject.url).to eq("http://www.example.com")
    end

    it "does not add http:// to url if http:// is already present" do
      subject.validate
      expect(subject.url).to eq("http://www.example.com")
    end

    it "does not add http:// to url if https:// is already present" do
      subject.url = "https://www.example.com"
      subject.validate
      expect(subject.url).to eq("https://www.example.com")
    end
  end
end
