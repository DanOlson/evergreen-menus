class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to account_path(current_user.account)
    end
  end
end
