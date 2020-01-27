# frozen_string_literal: true

require "digest"

STORE = {}

class UrlShortenerController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:index]

  def index
    json_params = JSON.parse(request.raw_post)
    short = Digest::MD5.hexdigest(json_params["url"])
    STORE[short] = json_params["url"]
    render json: { "short_url": "/#{short}", "url":  STORE[short] }
  rescue StandardError => error
    render json: { errors: [error] }, status: 500
  end

  def redirect
    redirect_to STORE[params["path"]], status: 301
  rescue StandardError => error
    render json: { errors: [error] }, status: 500
  end
end
