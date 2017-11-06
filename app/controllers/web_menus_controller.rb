class WebMenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :web_menu, through: :establishment

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def web_menu_params
    params.require(:web_menu).permit(
      :id,
      :name,
      {
        web_menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :show_description_on_menu,
          :_destroy
        ]
      }
    )
  end
end
