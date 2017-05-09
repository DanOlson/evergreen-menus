class MenuListsController < ApplicationController
  skip_before_action :verify_authenticity_token
  respond_to :js

  def show
    @list = List.find params[:id]
  end
end
