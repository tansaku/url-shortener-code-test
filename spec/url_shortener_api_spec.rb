# frozen_string_literal: true

require "rails_helper"

describe "Url Shortener", type: "request" do
  let(:valid_params) do
    {
      url: "http://www.farmdrop.com"
    }
  end

  let(:valid_params_without_http_prefix) do
    {
      url: "www.farmdrop.com"
    }
  end

  let(:invalid_params_empty_string) do
    {
      url: ""
    }
  end

  let(:invalid_params_no_url) do
    {
      url_missing: ""
    }
  end

  context "POST /" do
    # this around block ensures that the system supports using a simple curl operation
    # as requested in the specification, as this ensures the tests will fail
    #  if our rails controller does not skip the verify_authenticity_token checks
    # that usually ensure that we are submitting from a rails form
    # see https://stackoverflow.com/a/28947362/316729
    around do |example|
      ActionController::Base.allow_forgery_protection = true
      example.run
      ActionController::Base.allow_forgery_protection = false
    end

    it "should shorten urls" do
      post "/", params: valid_params, as: :json
      json = JSON.parse(response.body)
      expect(json["url"]).to eq "http://www.farmdrop.com"
      expect(json["short_url"]).to match(/[a-z0-9]+/)
    end

    it "should handle lack of http prefix gracefully" do
      post "/", params: valid_params_without_http_prefix, as: :json
      json = JSON.parse(response.body)
      expect(json["url"]).to eq "http://www.farmdrop.com"
      expect(json["short_url"]).to match(/[a-z0-9]+/)
    end

    it "should handle empty string gracefully" do
      post "/", params: invalid_params_empty_string, as: :json
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq ["Need valid URL for shortening"]
      expect(response.status).to eq 500
    end

    it "should handle no url gracefully" do
      post "/", params: invalid_params_no_url, as: :json
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq ["Must specify parameter url"]
      expect(response.status).to eq 500
    end
  end

  context "GET /<shortened_url>" do
    it "should redirect to original URL" do
      post "/", params: valid_params, as: :json
      short = JSON.parse(response.body)["short_url"]
      get "/#{short}"
      expect(response).to redirect_to "http://www.farmdrop.com"
      expect(response.status).to eq 301
    end

    it "handles case when there is no original URL" do
      get "/invalid"
      json = JSON.parse(response.body)
      expect(json["errors"]).to eq ["Cannot redirect to nil!"]
      expect(response.status).to eq 500
    end
  end
end
