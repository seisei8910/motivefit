class Users::SessionsController < ApplicationController
  skip_before_action :configure_authentication, only: :guest_sign_in

  def guest_sign_in
    user = User.guest
    sign_in user
    redirect_to user_path(user), notice: "guestuserでログインしました。"
  end
end
