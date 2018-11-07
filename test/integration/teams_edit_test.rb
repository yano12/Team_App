require 'test_helper'

class TeamsEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @player = players(:michael)
    @non_manager = players(:archer)
    @team = teams(:suns)
  end

  test "unsuccessful edit" do
    log_in_as(@player)
    get edit_team_path(@team)
    assert_template 'teams/edit'
    patch team_path(@team), params: { team: { name:  "",
                                              password:              "foo",
                                              password_confirmation: "bar" } }
    assert_template 'teams/edit'
    log_in_as(@non_manager)
    get edit_team_path(@team)
    assert_redirected_to edit_player_path(@non_manager)
  end
  
  test "successful edit" do
    log_in_as(@player)
    get edit_team_path(@team)
    assert_template 'teams/edit'
    name  = "Phoenix"
    patch team_path(@team), params: { team: { name:  name,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @team
    @team.reload
    assert_equal name,  @team.name
  end
end
