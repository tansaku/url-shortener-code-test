# frozen_string_literal: true

require "rails_helper"

describe "post /", type: "request" do
  let(:valid_params) do
    {
      url: "http://www.farmdrop.com"
    }
  end

  let(:expected_response) do
    '{"short_url":"/abc123","url":"http://www.farmdrop.com"}'
  end

  it "should shorten urls" do
    post "/", params: valid_params
    expect(response.body).to eq expected_response
  end
end
