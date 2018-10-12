require 'test_helper'

class PlayersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'Team.count' do
      post players_path, params: { player: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'players/new'
  end
  
  test "valid signup information" do
    get signup_path
    assert_difference 'Player.count', 1 do
      post signup_path, params: { player: { name:  "Example Player",
                                         email: "player@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'players/show'
    assert_not flash.empty?
  end
end
