class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #devise利用の機能（ユーザ登録、ログイン認証など）の前に実行
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :is_notification
  before_action :set_user

  #ログイン後の画面遷移
  def after_sign_in_path_for(resource)
    search_users_path
  end
  #ログアウト後の画面遷移
  def after_sign_out_path_for(resource)
    root_path
  end

  private

  def set_user
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end

  #ログインユーザーがグループに招待されているか
  def is_notification
   if user_signed_in?
      @is_notification = GroupUser.where(user_id: current_user.id).where(is_confirmed: false)
   end
  end

  #他のコントローラからも参照可能
  protected
  #sign_up,sign_in,account_updateの際に、keyのデータを許可
  def configure_permitted_parameters
    added_attrs = [:email, :nick_name, :password, :password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
