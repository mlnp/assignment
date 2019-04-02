class UrlsController < ApplicationController

  def create
    long_url = params[:url]
    shortcode = params[:code]
    @url = Url.create({
      url: long_url,
      shortcode: shortcode,
      })
    if @url.errors.empty?
      render json: @url
    else
      render json: {error: @url.errors.full_messages.join("; ")}, status: 422
    end
  end

  private

  def url_params
    params.permit(:url, :shortcode)
  end

end
