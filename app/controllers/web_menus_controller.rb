class WebMenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :web_menu, through: :establishment

  def new
    @web_menu.name = 'New Web Menu'
  end

  def create
    if @web_menu.valid?
      @web_menu.save
      redirect_to edit_account_establishment_web_menu_path(@account, @establishment, @web_menu), notice: 'Web menu created'
    else
      logger.debug("\n\nWeb Menu invalid! #{@web_menu.errors.full_messages}\n\n")
      render :new
    end
  end

  def edit
  end

  def update
    if @web_menu.update(web_menu_params)
      redirect_to edit_account_establishment_web_menu_path(@account, @establishment, @web_menu), notice: 'Web menu updated'
    else
      logger.debug("\n\nMenu invalid! #{@web_menu.errors.full_messages}\n\n")
      render :edit
    end
  end

  def show
  end

  def destroy
    @web_menu.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Web menu deleted'
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
