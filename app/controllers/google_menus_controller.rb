class GoogleMenusController < ApplicationController
  load_and_authorize_resource :account, except: :show
  load_and_authorize_resource :establishment, through: :account, except: :show
  load_and_authorize_resource :google_menu, through: :establishment, except: :show, singleton: true

  def edit
  end

  def update
  end

  def preview
  end
end
