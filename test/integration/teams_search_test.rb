require 'test_helper'

class TeamsSearchTestTest < ActionDispatch::IntegrationTest
  
  def setup 
    @team = teams(:suns)
  end
  
  test "index and search test" do 
    get teams_path
    assert_template 'teams/index'
    assert_select 'div.pagination', count: 2
    first_page_of_teams = Team.paginate(page: 1)
    first_page_of_teams.each do |team|
      assert_select 'a[href=?]', team_path(team), text: team.name
    end
    get team_path(@team)
    assert_template 'teams/show'
    assert_select 'div.pagination', count: 1
    first_page_of_players = Player.paginate(page: 1)
    first_page_of_players.each do |player|
      assert_select 'a[href=?]', player_path(player), text: player.name
    end
  end
end
