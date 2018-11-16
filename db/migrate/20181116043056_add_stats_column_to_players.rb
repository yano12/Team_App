class AddStatsColumnToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :game_count, :integer  #試合数
    add_column :players, :play_time, :float     #総プレイ時間
    add_column :players, :minpg, :float         #平均プレイ時間
    add_column :players, :pts, :integer         #得点数
    add_column :players, :ppg, :float           #平均得点数
    add_column :players, :fgpg, :float          #フィールドゴール成功率
    add_column :players, :three_m, :integer     #3Pシュート成功数
    add_column :players, :three_a, :integer     #3Pシュート試投数
    add_column :players, :threepg, :float       #3Pシュート成功率
    add_column :players, :ftm, :integer         #フリースロー成功数
    add_column :players, :fta, :integer         #フリースロー試投数
    add_column :players, :ftpg, :float          #フリースロー成功率
    add_column :players, :ofr, :integer         #オフェンスリバウンド数
    add_column :players, :dfr, :integer         #ディフェンスリバウンド数
    add_column :players, :tor, :integer         #トータルリバウンド数
    add_column :players, :rpg, :float           #平均リバウンド数
    add_column :players, :assist, :integer      #アシスト数
    add_column :players, :apg, :float           #平均アシスト数
    add_column :players, :tover, :integer       #ターンオーバー数
    add_column :players, :steal, :integer       #スティール数
    add_column :players, :stpg, :float          #平均スティール数
    add_column :players, :blockshot, :integer   #ブロック数
    add_column :players, :bspg, :float          #平均ブロック数
    add_column :players, :foul, :integer        #ファウル数
  end
end
