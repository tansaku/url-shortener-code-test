# frozen_string_literal: true

require "digest"

class UrlShortenerController < ApplicationController
  STORE = {}
  SHORTENED_URL_LENGTH = 6

  skip_before_action :verify_authenticity_token, only: [:index]

  def index
    short_url = shorten_url_and_store
    render json: { "short_url": "/#{short_url}", "url":  STORE[short_url] }
  rescue StandardError => error
    render json: { errors: [error] }, status: 500
  end

  def redirect
    redirect_to STORE[params["path"]], status: 301
    rescue StandardError => error
      render json: { errors: [error] }, status: 500
  end

  private
    def shorten_url_and_store
      url = url_from_json_params
      short = Digest::MD5.hexdigest(url)[0...SHORTENED_URL_LENGTH]
      STORE[short] = url
      short
    end

    def url_from_json_params
      json_params = JSON.parse(request.raw_post)
      raise "Must specify parameter url" unless json_params["url"]
      url = json_params["url"]
      raise "Need valid URL for shortening" if url.empty?
      ensure_http_prefix(url)
    end

    def ensure_http_prefix(url)
      url.starts_with?("http") ? url : "http://#{url}"
    end
end
