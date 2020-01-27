# frozen_string_literal: true

require "rails_helper"

describe "post /", type: "request" do
  let(:valid_params) do
    {
      url: "http://www.farmdrop.com"
    }
  end

  it "should shorten urls" do
    post "/", params: valid_params
  end
end
