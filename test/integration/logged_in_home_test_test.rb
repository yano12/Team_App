require 'test_helper'

class LoggedInHomeTestTest < ActionDispatch::IntegrationTest
  
  def setup
    @team = teams(:suns)
    @admin     = players(:michael)
    @non_admin = players(:archer)
    @non_activated_player = players(:non_activated)
  end
  
  #test "top page as admin including pagination and delete links" do
  #  log_in_as @admin
  #  get root_path
  #  assert_template '/'
  #  assert_select 'div.pagination'
  #  first_page_of_players = Player.paginate(page: 1)
  #  first_page_of_players.each do |player|
  #    assert_select 'a[href=?]', player_path(player), text: player.name
  #  end
  #end
  
  #test "top page as non-admin" do
  #  log_in_as(@non_admin)
  # get root_path
  #assert_select 'a', text: 'delete', count: 0
  #end
end
