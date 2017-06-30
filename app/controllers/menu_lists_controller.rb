class MenuListsController < ApplicationController
  skip_before_action :verify_authenticity_token, :authenticate_user!
  respond_to :js

  def show
    @list = List.find params[:id]
  end
end
