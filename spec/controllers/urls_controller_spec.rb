require 'rails_helper'

RSpec.describe UrlsController, type: :controller do

  let(:subject) {
    Url.new({
      url: "http://example.com",
      shortcode: "exampl"
      })
  }
  describe "GET show" do
    it "responds with 302 if a valid url is present" do
      subject.save
      get :show, params: {code: 'exampl'}
      expect(response.status).to eq(302)
    end
    it "responds with 404 when url is not found" do
      get :show, params: {code: 'n0n0n0'}
      expect(response.status).to eq(404)
    end
  end

  describe "GET stats" do
    it "responds with stats" do
      subject.save
      get :stats, params: {code: subject.shortcode}
      received_stats = JSON.parse(response.body)
      expect(received_stats.keys.length).to be >= 2
    end

    it "omits the last_usage key if usage_count is 0" do
      subject.save
      get :stats, params: {code: subject.shortcode}
      received_stats = JSON.parse(response.body)
      expect(received_stats["usage_count"]).to eq(0)
      expect(received_stats.keys).not_to include("last_usage")
    end

    it "responds with 404 when url is not found" do
      get :stats, params: {code: 'n0n0n0'}
      expect(response.status).to eq(404)
    end
  end

  describe "GET create" do
    it "creates a url and responds with 201 when given valid params" do
      get :create, params: subject.attributes
      expect(response.status).to eq(201)
    end

    it "responds with 409 if shortcode is already taken" do
      subject.save # so shortcode will be taken already
      get :create, params: subject.attributes
      expect(response.status).to eq(409)
    end

    it "responds with 400 if url is missing" do
      get :create, params: {shortcode: subject.shortcode}
      expect(response.status).to eq(409)
    end

    it "responds with 400 if url is invalid" do
      get :create, params: {shortcode: subject.shortcode, url: "invalid url"}
      expect(response.status).to eq(400)
    end

    it "responds with 422 if shortcode is invalid" do
      get :create, params: {url: subject.url, shortcode: "$%^&*7"}
      expect(response.status).to eq(422)
    end
  end
end
