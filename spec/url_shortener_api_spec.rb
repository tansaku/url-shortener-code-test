# frozen_string_literal: true

require "rails_helper"

describe "Url Shortener", type: "request" do
  let(:valid_params) do
    {
      url: "http://www.farmdrop.com"
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

    fit "should shorten urls" do
      post "/", params: valid_params, as: :json
      json = JSON.parse(response.body)
      expect(json["url"]).to eq "http://www.farmdrop.com"
      expect(json["short_url"]).to match(/[a-z0-9]+/)
    end
  end

  context "GET" do
    fit "should redirect to original URL" do
      post "/", params: valid_params, as: :json
      short = JSON.parse(response.body)["short_url"]
      get "/#{short}"
      expect(response).to redirect_to "http://www.farmdrop.com"
      expect(response.status).to eq 301
    end
  end
end
