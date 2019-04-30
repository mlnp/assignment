require 'rails_helper'

RSpec.describe Url, type: :model do

  let(:subject) {
    Url.new url: "http://mlnp.com", code: "mlnpru"
  }

  describe "presence validation" do
    it "is valid with all proper attributes" do
      expect(subject).to be_valid
    end

    it "is invalid when url is nil" do
      subject.url = nil
      expect(subject).not_to be_valid
    end
  end
end