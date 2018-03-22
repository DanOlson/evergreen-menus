class AmpListsController < ApplicationController
  ACCESS_CONTROL_ALLOW_HEADERS = 'Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token'.freeze
  ACCESS_CONTROL_ALLOW_METHODS = 'GET, OPTIONS'.freeze
  ACCESS_CONTROL_AMP_ALLOW_SOURCE_ORIGIN = 'AMP-Access-Control-Allow-Source-Origin'.freeze
  skip_before_action :authenticate_user!
  after_action :set_cors_headers

  def show
    list = List.find params[:id]
    amp_list = AmpListSerializer.new(list).call
    render json: amp_list, status: :ok
  end

  private

  def set_cors_headers
    response.set_header 'access-control-allow-headers', ACCESS_CONTROL_ALLOW_HEADERS
    response.set_header 'access-control-allow-credentials', 'true'
    response.set_header 'amp-access-control-allow-source-origin', params['__amp_source_origin']
    response.set_header 'access-control-allow-methods', ACCESS_CONTROL_ALLOW_METHODS
    response.set_header 'access-control-expose-headers', ACCESS_CONTROL_AMP_ALLOW_SOURCE_ORIGIN
    set_access_control_allow_origin
  end

  ###
  # TODO: Here we should check entitlements...
  def set_access_control_allow_origin
    header_val = if request.headers['AMP-Same-Origin'] == 'true'
      params['__amp_source_origin']
    else
      request.headers['Origin']
    end
    response.set_header 'access-control-allow-origin', header_val
  end
end
