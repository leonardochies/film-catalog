require 'rails_helper'

RSpec.describe Movie, type: :model do
  describe "validações" do
    it "é válido com todos os atributos" do
      movie = FactoryBot.build(:movie)
      expect(movie).to be_valid
    end

    it "é inválido sem título" do
      movie = FactoryBot.build(:movie, title: nil)
      expect(movie).not_to be_valid
      expect(movie.errors[:title]).to include("não pode ficar em branco")
    end

    it "é inválido sem sinopse" do
      movie = FactoryBot.build(:movie, synopsis: nil)
      expect(movie).not_to be_valid
    end

    it "é inválido com sinopse muito curta" do
      movie = FactoryBot.build(:movie, synopsis: "Curta")
      expect(movie).not_to be_valid
      expect(movie.errors[:synopsis]).to be_present
    end

    it "é inválido sem ano de lançamento" do
      movie = FactoryBot.build(:movie, release_year: nil)
      expect(movie).not_to be_valid
    end

    it "é inválido sem duração" do
      movie = FactoryBot.build(:movie, duration: nil)
      expect(movie).not_to be_valid
    end

    it "é inválido sem diretor" do
      movie = FactoryBot.build(:movie, director: nil)
      expect(movie).not_to be_valid
    end

    it "é inválido sem usuário" do
      movie = FactoryBot.build(:movie, user: nil)
      expect(movie).not_to be_valid
    end
  end

  describe "associações" do
    it "pertence a um usuário" do
      movie = FactoryBot.create(:movie)
      expect(movie.user).to be_present
      expect(movie.user).to be_a(User)
    end

    it "pode ter muitos comentários" do
      movie = FactoryBot.create(:movie)
      comment1 = FactoryBot.create(:comment, movie: movie)
      comment2 = FactoryBot.create(:comment, movie: movie)

      expect(movie.comments.count).to eq(2)
    end

    it "pode ter muitas categorias" do
      movie = FactoryBot.create(:movie)
      category1 = FactoryBot.create(:category)
      category2 = FactoryBot.create(:category)

      movie.categories << [ category1, category2 ]

      expect(movie.categories.count).to eq(2)
    end

    it "deleta comentários quando é deletado" do
      movie = FactoryBot.create(:movie)
      comment = FactoryBot.create(:comment, movie: movie)

      expect { movie.destroy }.to change { Comment.count }.by(-1)
    end
  end

  describe "Active Storage" do
    it "pode ter um poster anexado" do
      movie = FactoryBot.create(:movie, :with_poster)
      expect(movie.poster).to be_attached
    end
  end

  describe "scope smart_search" do
    let!(:matrix) { FactoryBot.create(:movie, title: "The Matrix", director: "Wachowski", release_year: 1999) }
    let!(:inception) { FactoryBot.create(:movie, title: "Inception", director: "Nolan", release_year: 2010) }

    it "busca por título" do
      results = Movie.smart_search("Matrix")
      expect(results).to include(matrix)
      expect(results).not_to include(inception)
    end

    it "busca por diretor" do
      results = Movie.smart_search("Nolan")
      expect(results).to include(inception)
      expect(results).not_to include(matrix)
    end

    it "busca por ano" do
      results = Movie.smart_search("1999")
      expect(results).to include(matrix)
      expect(results).not_to include(inception)
    end

    it "busca por diretor e ano" do
      results = Movie.smart_search("Nolan 2010")
      expect(results).to include(inception)
      expect(results).not_to include(matrix)
    end

    it "retorna todos quando busca vazia" do
      results = Movie.smart_search("")
      expect(results.count).to eq(2)
    end
  end
end
