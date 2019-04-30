require 'rails_helper'

RSpec.describe UrlsController, type: :controller do
	let(:existing_url) do
		Url.create({ url: "http://mlnp.com", code: "myshor" })
	end

	describe "#create" do
		it "responds with 400 if :url param not passed" do
			expect do
				post :create, params: nil
			end.to raise_error(ActionController::ParameterMissing)
		end

		it "responds with 201" do
			post :create, params: { 'url': 'whoknows.com' }
			expect(response.status).to eq(201)
		end

		it "responds with 422 if passed an invalid shortcode" do
			post :create, params: { 'url': 'whoknows.com', code: '$%&^*(' }
			expect(response.status).to eq(422)
		end
	end

  describe "#show" do
    it "responds with 200" do
      get :show, params: { code: existing_url.code }
      expect(response.status).to eq(200)
    end

    it "responds with correct JSON" do
      get :show, params: { code: existing_url.code }
      expect(JSON.parse(response.body)['url']).to eq(existing_url.url)
    end

    it "responds with 404" do
      get :show, params: { code: 'n0n0n0' }
      expect(response.status).to eq(404)
    end

    it "updates the usage_count" do
    	expect do
      	get :show, params: { code: existing_url.code }
      end.to change { existing_url.reload.hits }.from(0).to(1)
    end
  end

  describe "#stats" do
    it "responds with 200" do
      get :stats, params: { code: existing_url.code }
      expect(response.status).to eq(200)
    end

    it "responds with correct JSON" do
      get :stats, params: { code: existing_url.code }
      expect(JSON.parse(response.body)['created_at']).to eq(existing_url.created_at.to_formatted_s(:iso8601))
      expect(JSON.parse(response.body)['last_usage']).to eq(existing_url.updated_at.to_formatted_s(:iso8601))
      expect(JSON.parse(response.body)['usage_count']).to eq(existing_url.hits)
    end

    it "responds with 404" do
      get :stats, params: { code: 'n0n0n0' }
      expect(response.status).to eq(404)
    end
  end
end