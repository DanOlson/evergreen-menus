class MenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :menu, through: :establishment

  def new
  end

  def show
  end

  def edit
  end

  def create
    if @menu.valid?
      @menu.save
      redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Menu created'
    else
      render :new
    end
  end

  def update
  end

  def destroy
  end

  private

  def menu_params
    params.require(:menu).permit(:name)
  end
end
