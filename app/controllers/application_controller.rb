class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include TeamSessionsHelper

  private

    # ログイン済みユーザーかどうか確認
    def logged_in_player
      unless logged_in?
        store_location
        flash[:danger] = "ログインしてください"
        redirect_to login_url
      end
    end
end
