class Comment < ApplicationRecord
  validates :player_id, presence: true
  validates :content, presence: true,length:{maximum:100}

  belongs_to :player
  belongs_to :micropost

  counter_culture :micropost
  
  # 関連付けの自己結合(Railsガイド:　https://railsguides.jp/association_basics.html)
  has_many :replies,class_name:'Comment', foreign_key: :parent_id, dependent: :destroy    # 子コメント
  belongs_to :parent, class_name:'Comment', optional:true                                 # 親コメント
end
