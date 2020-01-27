# frozen_string_literal: true

require "rails_helper"

describe "Url Shortener", type: "request" do
  let(:valid_params) do
    {
      url: "http://www.farmdrop.com"
    }
  end

  let(:expected_response) do
    '{"short_url":"/abc123","url":"http://www.farmdrop.com"}'
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
      post "/", params: valid_params
      expect(response.body).to eq expected_response
    end
  end

  context "GET" do
    it "should redirect to original URL" do
      get "/abc123"
      expect(response).to redirect_to "http://www.farmdrop.com"
      expect(response.status).to eq 301
    end
  end
end
