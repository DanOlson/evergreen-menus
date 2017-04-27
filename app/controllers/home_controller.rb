class HomeController < ApplicationController
  def index
    if user_signed_in?
      redirect_to after_sign_in_path_for(current_user)
    end
  end
end
