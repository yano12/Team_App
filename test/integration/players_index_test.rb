require 'test_helper'

class PlayersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin     = players(:michael)
    @non_admin = players(:archer)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get players_path
    assert_template 'players/index'
    assert_select 'div.pagination'
    first_page_of_players = Player.paginate(page: 1)
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name
      unless player == @admin
        assert_select 'a[href=?]', player_path(player), text: 'delete'
      end
    end
    assert_difference 'Player.count', -1 do
      delete player_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get players_path
    assert_select 'a', text: 'delete', count: 0
  end
end
