# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  if ENV['BASIC_AUTH_NAME'] && ENV['BASIC_AUTH_PASSWORD']
    http_basic_authenticate_with \
      name: ENV['BASIC_AUTH_NAME'],
      password: ENV['BASIC_AUTH_PASSWORD']
  end

  # Select language dynamically
  before_action :handle_locale

  def handle_locale
    # Explicitly requested locales will be stored as cookies
    if params[:locale]
      cookies[:locale] = { value: params[:locale], expires: 1.year.from_now }
    end

    # Apply the stored or header locale if valid, otherwise choose default
    available_locales = I18n.available_locales.map(&:to_s)
    requested_locale = cookies[:locale] || extract_locale_from_headers
    if not available_locales.include?(requested_locale)
      requested_locale = I18n.default_locale
    end

    I18n.locale = requested_locale
  end

  def extract_locale_from_headers
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end
end
