require 'test_helper'

class PlayersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @player = players(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@player)
    get edit_player_path(@player)
    assert_template 'players/edit'
    patch player_path(@player), params: { player: { team_manager: false,
                                              name:  "",
                                              email: "foo@invalid",
                                              password:              "foo",
                                              password_confirmation: "bar" } }

    assert_template 'players/edit'
  end
  
  test "successful edit with friendly forwarding" do
    log_in_as(@player)
    get edit_player_path(@player)
    assert_template 'players/edit'
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch player_path(@player), params: { player: { team_manager: false,
                                              name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @player
    @player.reload
    assert_equal name,  @player.name
    assert_equal email, @player.email
    assert_not @player.team_manager?
  end
end
