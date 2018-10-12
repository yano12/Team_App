require 'test_helper'

class TeamsSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    get new_team_path
    assert_no_difference 'Team.count' do
      post teams_path, params: { team: { name:  "",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'teams/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert-danger'
  end
  
  test "valid signup information" do
    get new_team_path
    assert_difference 'Team.count', 1 do
      post teams_path, params: { team: { name:  "Example Team",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    # assert_template 'users/new' チームアカウントを作成したらユーザー登録ページに
    assert_not flash.empty?
  end
end
