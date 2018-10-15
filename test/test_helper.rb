ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests
  # in alphabetical order.
  fixtures :all
  include ApplicationHelper
  
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:player_id].nil?
  end
  
  # テストユーザーとしてログインする
  def log_in_as(player)
    session[:player_id] = player.id
  end
end

class ActionDispatch::IntegrationTest

  # テストユーザーとしてログインする
  def log_in_as(player, password: 'password', remember_me: '1')
    post login_path, params: { session: { email: player.email,
                                          password: password,
                                          remember_me: remember_me } }
  end
end