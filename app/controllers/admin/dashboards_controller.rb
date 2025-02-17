class Admin::DashboardsController < ApplicationController
  layout 'admin'
  def index
    @users = User.all.page(params[:page])
  end
end
