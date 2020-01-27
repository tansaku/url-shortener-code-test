# frozen_string_literal: true

class UrlShortenerController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]

  def index
    render json: { "short_url": "/abc123", "url": "http://www.farmdrop.com" }
  end

  def redirect
    redirect_to "http://www.farmdrop.com", status: 301
  end
end
