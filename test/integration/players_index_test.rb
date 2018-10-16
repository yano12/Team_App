require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
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
end