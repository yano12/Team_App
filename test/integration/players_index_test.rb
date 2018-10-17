require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
    @non_activated_player = players(:non_activated)
  end

  test "show and index including pagination and delete links" do
    get team_path(@team)
    assert_template 'teams/show'
    assert_select 'div.pagination'
    first_page_of_players = Player.paginate(page: 1)
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name
    end
  end
  
  test "should not allow the not activated attribute" do
    log_in_as(@non_activated_player)
    assert_not @non_activated_player.activated?
    get team_path(@team)
    assert_select "a[href=?]", player_path(@non_activated_player), count: 0
    get player_path(@non_activated_player)
    assert_redirected_to root_url
  end
end