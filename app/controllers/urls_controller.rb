class UrlsController < ApplicationController

  def create
    long_url = params[:url]
    shortcode = params[:code]
    logger.info "url: #{long_url}"
    logger.info "shortcode: #{shortcode}"
    @url = Url.create({
      url: long_url,
      shortcode: shortcode,
      })
    if @url.errors.empty?
      render json: {code: @url.shortcode}, status: 201
    elsif @url.errors.details[:shortcode].any? { |e| e[:error] == :taken }
      # If shortcode is already taken, need to return a 409 instead of 422
      render json: {error: @url.errors.full_messages.join("; ")}, status: 409
    elsif @url.errors.details[:url].any? { |e| e[:error] == :invalid_url }
      render json: {error: @url.errors.full_messages.join("; ")}, status: 400
    else
      render json: {error: @url.errors.full_messages.join("; ")}, status: 422
    end
  end

  def show
    code = params[:code]
    @url = Url.find_by(shortcode: code)

    if @url
      # Rails will give us a 302 :)
      redirect_to @url.url
    else
      render json: {error: "Shortcode #{code} not found"}, status: 404
    end
  end

  private

  def url_params
    params.permit(:url, :shortcode)
  end

end
