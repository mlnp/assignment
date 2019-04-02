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
end
