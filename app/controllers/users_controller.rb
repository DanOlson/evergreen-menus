class UsersController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :user, through: :account

  def index
  end
end
