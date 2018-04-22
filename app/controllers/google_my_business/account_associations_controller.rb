module GoogleMyBusiness
  class AccountAssociationsController < ApplicationController
    load_resource :account, id_param: :account_id, class: '::Account'

    def new
      authorize! :manage, :google_my_business
      @account = @account.decorate
    end

    def create
      authorize! :manage, :google_my_business
      if @account.update account_params
        redirect_to new_account_google_my_business_establishment_association_path(@account), notice: 'Account association was successful'
      else
        render :new, alert: @account.errors.full_messages.join("\n")
      end
    end

    private

    def account_params
      params.require(:account).permit(:google_my_business_account_id)
    end
  end
end
