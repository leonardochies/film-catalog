require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:movie) { FactoryBot.create(:movie) }
  let(:locale) { :'pt-BR' }

  describe "POST /movies/:movie_id/comments" do
    let(:valid_attributes) do
      { content: "Great movie!" }
    end

    let(:invalid_attributes) do
      { content: nil }
    end

    context "quando usuário está logado" do
      before { sign_in user }

      context "com parâmetros válidos" do
        it "cria um novo comentário" do
          expect {
            post movie_comments_path(movie, locale: locale), params: { comment: valid_attributes }
          }.to change(Comment, :count).by(1)
        end

        it "associa comentário ao usuário" do
          post movie_comments_path(movie, locale: locale), params: { comment: valid_attributes }
          expect(Comment.last.user).to eq(user)
        end

        it "associa comentário ao filme" do
          post movie_comments_path(movie, locale: locale), params: { comment: valid_attributes }
          expect(Comment.last.movie).to eq(movie)
        end

        it "redireciona para o filme" do
          post movie_comments_path(movie, locale: locale), params: { comment: valid_attributes }
          expect(response).to redirect_to(movie)
        end
      end

      context "com parâmetros inválidos" do
        it "não cria comentário" do
          expect {
            post movie_comments_path(movie, locale: locale), params: { comment: invalid_attributes }
          }.not_to change(Comment, :count)
        end
      end
    end

    context "quando usuário não está logado (comentário anônimo)" do
      context "com nome e conteúdo válidos" do
        let(:anonymous_attributes) do
          {
            author_name: "Anonymous User",
            content: "Great movie!"
          }
        end

        it "cria um novo comentário" do
          expect {
            post movie_comments_path(movie, locale: locale), params: { comment: anonymous_attributes }
          }.to change(Comment, :count).by(1)
        end

        it "cria comentário sem usuário" do
          post movie_comments_path(movie, locale: locale), params: { comment: anonymous_attributes }
          expect(Comment.last.user).to be_nil
        end

        it "salva o nome do autor" do
          post movie_comments_path(movie, locale: locale), params: { comment: anonymous_attributes }
          expect(Comment.last.author_name).to eq("Anonymous User")
        end
      end

      context "sem nome de autor" do
        let(:invalid_anonymous) do
          {
            author_name: nil,
            content: "Great movie!"
          }
        end

        it "não cria comentário" do
          expect {
            post movie_comments_path(movie, locale: locale), params: { comment: invalid_anonymous }
          }.not_to change(Comment, :count)
        end
      end
    end
  end
end
