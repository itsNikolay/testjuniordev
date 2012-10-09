class Admin::BaseController < ApplicationController
  before_filter :authenticate_user!, :admin_user?
 
  layout "admin/admin"

  def index
  end
private
  def admin_user?
   redirect_to root_path, :alert => 'This page is allowed for admin' unless current_user.admin
  end

end
