class AddStatsColumnToPlayers < ActiveRecord::Migration[5.1]
  def change
    add_column :players, :game_count, :integer, default: 0  #試合数
    add_column :players, :play_time, :integer, default: 0   #プレイ時間
    add_column :players, :minpg, :float, default: 0         #平均プレイ時間
    add_column :players, :pts, :integer, default: 0         #得点数
    add_column :players, :ppg, :float, default: 0           #平均得点数
    add_column :players, :fgm, :integer, default: 0         #フィールドゴール成功数
    add_column :players, :fga, :integer, default: 0         #フィールドゴール試投数
    add_column :players, :fgpg, :float, default: 0          #フィールドゴール成功率
    add_column :players, :three_m, :integer, default: 0     #3Pシュート成功数
    add_column :players, :three_a, :integer, default: 0     #3Pシュート試投数
    add_column :players, :threepg, :float, default: 0       #3Pシュート成功率
    add_column :players, :ftm, :integer, default: 0         #フリースロー成功数
    add_column :players, :fta, :integer, default: 0         #フリースロー試投数
    add_column :players, :ftpg, :float, default: 0          #フリースロー成功率
    add_column :players, :ofr, :integer, default: 0         #オフェンスリバウンド数
    add_column :players, :dfr, :integer, default: 0         #ディフェンスリバウンド数
    add_column :players, :tor, :integer, default: 0         #トータルリバウンド数
    add_column :players, :rpg, :float, default: 0           #平均リバウンド数
    add_column :players, :assist, :integer, default: 0      #アシスト数
    add_column :players, :apg, :float, default: 0           #平均アシスト数
    add_column :players, :tover, :integer, default: 0       #ターンオーバー数
    add_column :players, :steal, :integer, default: 0       #スティール数
    add_column :players, :stpg, :float, default: 0          #平均スティール数
    add_column :players, :blockshot, :integer, default: 0   #ブロック数
    add_column :players, :bspg, :float, default: 0          #平均ブロック数
    add_column :players, :foul, :integer, default: 0        #ファウル数
  end
end
