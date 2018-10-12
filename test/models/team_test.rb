require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  
  def setup
    @team = Team.new(name: "Example Team",
                     password: "basket", password_confirmation: "basket")
  end

  test "should be valid" do
    assert @team.valid?
  end
  
  test "name should be present" do
    @team.name = "     "
    assert_not @team.valid?
  end
  
  test "name should not be too long" do
    @team.name = "a" * 101
    assert_not @team.valid?
  end
  
  test "name should be unique" do
    duplicate_team = @team.dup
    @team.save
    assert_not duplicate_team.valid?
  end
  
  test "password should be present (nonblank)" do
    @team.password = @team.password_confirmation = " " * 6
    assert_not @team.valid?
  end

  test "password should have a minimum length" do
    @team.password = @team.password_confirmation = "a" * 5
    assert_not @team.valid?
  end
  
  test "associated players should be destroyed" do
    @team.save
    @team.players.create!(name: "kobe", email: "kobe@example.com",
                        password: "password", password_confirmation: "password")
    assert_difference 'Player.count', -1 do
      @team.destroy
    end
  end
end
