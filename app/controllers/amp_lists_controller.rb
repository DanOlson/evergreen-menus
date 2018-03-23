class AmpListsController < ApplicationController
  ACCESS_CONTROL_ALLOW_HEADERS = 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'.freeze
  ACCESS_CONTROL_ALLOW_METHODS = 'GET, OPTIONS'.freeze
  ACCESS_CONTROL_AMP_ALLOW_SOURCE_ORIGIN = 'AMP-Access-Control-Allow-Source-Origin'.freeze
  skip_before_action :authenticate_user!
  after_action :set_cors_headers

  def show
    if !list
      render json: { message: 'Not found' }, status: :not_found and return
    end

    if entitled?
      amp_list = AmpListSerializer.new(list).call
      render json: amp_list, status: :ok
    else
      render json: { message: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def list
    @list ||= List.find_by_id params[:id]
  end

  def set_cors_headers
    response.set_header 'access-control-allow-headers', ACCESS_CONTROL_ALLOW_HEADERS
    response.set_header 'access-control-allow-credentials', 'true'
    response.set_header 'amp-access-control-allow-source-origin', source_origin
    response.set_header 'access-control-allow-methods', ACCESS_CONTROL_ALLOW_METHODS
    response.set_header 'access-control-expose-headers', ACCESS_CONTROL_AMP_ALLOW_SOURCE_ORIGIN
    set_access_control_allow_origin
  end

  def set_access_control_allow_origin
    header_val = same_origin_request? ? source_origin : origin
    response.set_header 'access-control-allow-origin', header_val
  end

  def source_origin
    params['__amp_source_origin']
  end

  def origin
    request.headers['Origin']
  end

  def same_origin_request?
    request.headers['AMP-Same-Origin'] == 'true'
  end

  def entitled?
    entitled = source_origin_valid? && list.establishment.account.active?
    same_origin_request? ? entitled : origin_allowed? && entitled
  end

  def origin_allowed?
    allowed_origins = [
      'cdn.ampproject.org',
      'amp.cloudflare.com',
      establishment_host
    ].map { |host| '.*' + host }.join('|')
    !!origin.match(/#{allowed_origins}/)
  end

  def establishment_host
    URI(list.establishment.url).host
  end

  def source_origin_valid?
    URI(source_origin).host == establishment_host
  end
end
