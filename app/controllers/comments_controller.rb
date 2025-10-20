class CommentsController < ApplicationController
  before_action :set_movie

  def create
    @comment = @movie.comments.build(comment_params)

    if user_signed_in?
      @comment.user = current_user
    end

    if @comment.save
      redirect_to @movie, notice: "Comentário adicionado com sucesso."
    else
      redirect_to @movie, alert: "Erro ao adicionar comentário."
    end
  end

  private

  def set_movie
    @movie = Movie.find(params[:movie_id])
  end

  def comment_params
    if user_signed_in?
      params.require(:comment).permit(:content)
    else
      params.require(:comment).permit(:content, :author_name)
    end
  end
end
