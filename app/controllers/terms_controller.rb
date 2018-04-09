class TermsController < ApplicationController
  skip_before_action :authenticate_user!

  def index
  end

  def privacy_policy
  end
end
