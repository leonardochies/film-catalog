require 'rails_helper'

RSpec.describe "Movies", type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:movie) { FactoryBot.create(:movie, user: user) }
  let(:category) { FactoryBot.create(:category) }
  let(:locale) { :'pt-BR' }  # <-- Define locale como variável

  describe "GET /movies" do
    it "retorna sucesso" do
      get movies_path(locale: locale)
      expect(response).to have_http_status(:success)
    end

    it "lista os filmes" do
      movie1 = FactoryBot.create(:movie, title: "Matrix")
      movie2 = FactoryBot.create(:movie, title: "Inception")

      get movies_path(locale: locale)
      expect(response.body).to include("Matrix")
      expect(response.body).to include("Inception")
    end
  end

  describe "GET /movies/:id" do
    it "retorna sucesso" do
      get movie_path(id: movie.id, locale: locale)  # <-- Passa id explicitamente
      expect(response).to have_http_status(:success)
    end

    it "exibe o filme" do
      get movie_path(id: movie.id, locale: locale)  # <-- Passa id explicitamente
      expect(response.body).to include(movie.title)
      expect(response.body).to include(movie.director)
    end
  end

  describe "GET /movies/new" do
    context "quando usuário está logado" do
      before { sign_in user }

      it "retorna sucesso" do
        get new_movie_path(locale: locale)
        expect(response).to have_http_status(:success)
      end
    end

    context "quando usuário não está logado" do
      it "redireciona para login" do
        get new_movie_path(locale: locale)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /movies" do
    let(:valid_attributes) do
      {
        title: "The Matrix",
        synopsis: "A computer hacker learns the truth about reality." * 5,
        release_year: 1999,
        duration: 136,
        director: "Wachowski Sisters",
        category_ids: [ category.id ]
      }
    end

    let(:invalid_attributes) do
      {
        title: nil,
        synopsis: "Short",
        release_year: nil
      }
    end

    context "quando usuário está logado" do
      before { sign_in user }

      context "com parâmetros válidos" do
        it "cria um novo filme" do
          expect {
            post movies_path(locale: locale), params: { movie: valid_attributes }
          }.to change(Movie, :count).by(1)
        end

        it "redireciona para o filme criado" do
          post movies_path(locale: locale), params: { movie: valid_attributes }
          expect(response).to redirect_to(movie_path(id: Movie.last.id, locale: locale))
        end

        it "associa o filme ao usuário logado" do
          post movies_path(locale: locale), params: { movie: valid_attributes }
          expect(Movie.last.user).to eq(user)
        end

        it "exibe mensagem de sucesso" do
          post movies_path(locale: locale), params: { movie: valid_attributes }
          follow_redirect!
          expect(response.body).to include("sucesso")
        end
      end

      context "com parâmetros inválidos" do
        it "não cria um novo filme" do
          expect {
            post movies_path(locale: locale), params: { movie: invalid_attributes }
          }.not_to change(Movie, :count)
        end

        it "retorna status unprocessable_entity" do
          post movies_path(locale: locale), params: { movie: invalid_attributes }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "renderiza o formulário novamente" do
          post movies_path(locale: locale), params: { movie: invalid_attributes }
          expect(response.body).to include("form")
        end
      end
    end

    context "quando usuário não está logado" do
      it "redireciona para login" do
        post movies_path(locale: locale), params: { movie: valid_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "não cria filme" do
        expect {
          post movies_path(locale: locale), params: { movie: valid_attributes }
        }.not_to change(Movie, :count)
      end
    end
  end

  describe "GET /movies/:id/edit" do
    context "quando é o dono do filme" do
      before { sign_in user }

      it "retorna sucesso" do
        get edit_movie_path(id: movie.id, locale: locale)
        expect(response).to have_http_status(:success)
      end
    end

    context "quando não é o dono do filme" do
      before { sign_in other_user }

      it "redireciona para root" do
        get edit_movie_path(id: movie.id, locale: locale)
        expect(response).to redirect_to(root_path)
      end

      it "exibe mensagem de erro" do
        get edit_movie_path(id: movie.id, locale: locale)
        follow_redirect!
        expect(response.body).to include("autorização")
      end
    end

    context "quando não está logado" do
      it "redireciona para login" do
        get edit_movie_path(id: movie.id, locale: locale)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "PATCH /movies/:id" do
    let(:new_attributes) do
      {
        title: "Matrix Reloaded",
        director: "Wachowski Brothers"
      }
    end

    context "quando é o dono do filme" do
      before { sign_in user }

      context "com parâmetros válidos" do
        it "atualiza o filme" do
          patch movie_path(id: movie.id, locale: locale), params: { movie: new_attributes }
          movie.reload
          expect(movie.title).to eq("Matrix Reloaded")
          expect(movie.director).to eq("Wachowski Brothers")
        end

        it "redireciona para o filme" do
          patch movie_path(id: movie.id, locale: locale), params: { movie: new_attributes }
          expect(response).to redirect_to(movie_path(id: movie.id, locale: locale))
        end
      end

      context "com parâmetros inválidos" do
        it "não atualiza o filme" do
          original_title = movie.title
          patch movie_path(id: movie.id, locale: locale), params: { movie: { title: nil } }
          movie.reload
          expect(movie.title).to eq(original_title)
        end

        it "retorna status unprocessable_entity" do
          patch movie_path(id: movie.id, locale: locale), params: { movie: { title: nil } }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    context "quando não é o dono do filme" do
      before { sign_in other_user }

      it "não atualiza o filme" do
        original_title = movie.title
        patch movie_path(id: movie.id, locale: locale), params: { movie: new_attributes }
        movie.reload
        expect(movie.title).to eq(original_title)
      end

      it "redireciona para root" do
        patch movie_path(id: movie.id, locale: locale), params: { movie: new_attributes }
        expect(response).to redirect_to(root_path)
      end
    end

    context "quando não está logado" do
      it "redireciona para login" do
        patch movie_path(id: movie.id, locale: locale), params: { movie: new_attributes }
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "DELETE /movies/:id" do
    context "quando é o dono do filme" do
      before { sign_in user }

      it "deleta o filme" do
        movie # cria o filme antes
        expect {
          delete movie_path(id: movie.id, locale: locale)
        }.to change(Movie, :count).by(-1)
      end

      it "redireciona para index" do
        delete movie_path(id: movie.id, locale: locale)
        expect(response).to redirect_to(movies_path(locale: locale))
      end
    end

    context "quando não é o dono do filme" do
      before { sign_in other_user }

      it "não deleta o filme" do
        movie # cria o filme antes
        expect {
          delete movie_path(id: movie.id, locale: locale)
        }.not_to change(Movie, :count)
      end

      it "redireciona para root" do
        delete movie_path(id: movie.id, locale: locale)
        expect(response).to redirect_to(root_path)
      end
    end

    context "quando não está logado" do
      it "redireciona para login" do
        delete movie_path(id: movie.id, locale: locale)
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
