class MenusController < ApplicationController
  load_and_authorize_resource :account
  load_and_authorize_resource :establishment, through: :account
  load_and_authorize_resource :menu, through: :establishment

  def new
  end

  def show
    respond_to do |format|
      format.html
      format.pdf {
        pdf = MenuBasicPdf.new menu: @menu
        send_data pdf.render, {
          filename: pdf.filename,
          type: 'application/pdf',
          disposition: params.key?(:download) ? 'attachment' : 'inline'
        }
      }
    end
  end

  def preview
    @menu = Menu.new menu_params
    menu_list_attrs = params[:menu][:menu_lists_attributes].values
    menu_list_ids = menu_list_attrs.map { |attrs| attrs[:id] }
    lists = MenuList.where(id: menu_list_ids).joins(:list).select('lists.*, menu_lists.show_price_on_menu')
    ordered_lists = menu_list_attrs.inject([]) do |memo, menu_list_attr|
      list = lists.find { |l| menu_list_attr[:list_id].to_i == l.id }
      list.show_price_on_menu = menu_list_attr[:show_price_on_menu] == '1'
      memo << list
    end
    @menu.updated_at = Time.now
    respond_to do |format|
      format.pdf {
        pdf = MenuBasicPdf.new menu: @menu, lists: ordered_lists
        send_data pdf.render, {
          filename: pdf.filename,
          type: 'application/pdf',
          disposition: params.key?(:download) ? 'attachment' : 'inline'
        }
      }
    end
  end

  def edit
  end

  def create
    if @menu.valid?
      @menu.save
      redirect_to edit_account_establishment_menu_path(@account, @establishment, @menu), notice: 'Menu created'
    else
      render :new
    end
  end

  def update
    if @menu.update(menu_params)
      redirect_to edit_account_establishment_menu_path(@account, @establishment, @menu), notice: 'Menu updated'
    else
      render :edit
    end
  end

  def destroy
    @menu.destroy
    redirect_to edit_account_establishment_path(@account, @establishment), notice: 'Menu deleted'
  end

  private

  def menu_params
    params.require(:menu).permit(
      :id,
      :name,
      {
        menu_lists_attributes: [
          :id,
          :list_id,
          :position,
          :show_price_on_menu,
          :_destroy
        ]
      }
    )
  end
end
