class CommentsController < ApplicationController
  before_action :logged_in_player, only:[:update, :create, :destroy]
  before_action :set_comment, only: [:reply, :edit, :update, :destroy]

  def reply
    @reply = @micropost.comments.build(parent: @comment)
  end

  def new
  end

  def create
    @micropost = Micropost.find_by(params[:micropost_id])
    @comment = @micropost.comments.build(comment_params)
    @comment.player = current_player
    if @comment.save
      # 返信先コメント(親コメント)があればreply_countを1増やす
      change_parentcomment if params[:comment][:parent_id].present?
      # respond_to でフォーマットを切り替える
      respond_to do |format|
        format.html { redirect_to @micropost, notice: "Comment was sucessfully created."}
        format.json { render json: @comment }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :back, notice: "Comment was not created." }
        format.json { render json: @comment.errors }
        format.js
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @micropost, notice: "Comment was sucessfully updated."}
        format.json { render json: @comment }
        format.js
      else
        format.html { render :back, notice: "Comment was not updated." }
        format.json { render json: @comment.errors }
        format.js
      end
    end
  end

  def destroy
    @comment.destroy if @comment.errors.empty?
    delete_commenthave @comment if @comment.parent_id.present?
    respond_to do |format|
      format.html {redirect_to @group, notice: "Comments was successfully destroyed."}
      format.json {head :no_content }
      format.js
    end
  end

  private

    def set_comment
      begin
        # 通常時の処理
        @micropost = Micropost.find(params[:id])
        @comment = @micropost.comments.find(params[:id])
      rescue => e
        # 例外処理
        logger.error "#{e.class.name} : #{e.message}"     # ログにどんなエラーが起こったかを出力
        @comment = @micropost.comments.build
        @comment.errors.add(:base, :recordnotfound, message: "That record doesn't exist. Maybe, it is already destroyed.")
      end
    end

  def change_parentcomment
    changecomment = Comment.find(params[:comment][:parent_id])    # 親コメントを取得
    changecomment.update(replies_count: changecomment.replies_count + 1)   # 親コメントのコメント数を1増やす
  end

  def delete_commenthave(comment)
    parent = comment.parent                                       # 親コメントを代入
    parent.update(replies_count: parent.replies_count - 1)         # 親コメントのコメント数を1減らす
  end

    def comment_params
      params.require(:comment).permit(:content, :parent_id, :image)
    end
end