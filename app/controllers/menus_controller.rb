class MenusController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def show
    @establishment = Establishment.find params[:id]
  end
end
