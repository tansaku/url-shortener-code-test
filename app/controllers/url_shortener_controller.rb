# frozen_string_literal: true

class UrlShortenerController < ApplicationController
  def index
    render json: { "short_url": "/abc123", "url": "http://www.farmdrop.com" }
  end

  def redirect
    redirect_to "http://www.farmdrop.com"
  end
end
