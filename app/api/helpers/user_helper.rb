module API::Helpers::UserHelper

  def set_user
    User.find(params[:id])
  end

end
