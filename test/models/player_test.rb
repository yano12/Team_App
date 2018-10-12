require 'test_helper'

class PlayerTest < ActiveSupport::TestCase

  def setup
    @team = teams(:suns)
    @player = @team.players.build(name: "Steve")
  end

  test "should be valid" do
    assert @player.valid?
  end

  test "team id should be present" do
    @player.team_id = nil
    assert_not @player.valid?
  end
  
  test "name should be present" do
    @player.name = "     "
    assert_not @player.valid?
  end
  
  test "name should not be too long" do
    @player.name = "a" * 51
    assert_not @player.valid?
  end
  
  #test "password should be present (nonblank)" do
  #  @player.password = @player.password_confirmation = " " * 6
  #  assert_not @player.valid?
  #end

  #test "password should have a minimum length" do
  #  @player.password = @player.password_confirmation = "a" * 5
  #  assert_not @player.valid?
  #end
end
