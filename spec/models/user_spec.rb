require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validações" do
    it "é válido com email e senha" do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it "é inválido sem email" do
      user = FactoryBot.build(:user, email: nil)
      expect(user).not_to be_valid
    end

    it "é inválido com email duplicado" do
      FactoryBot.create(:user, email: "test@example.com")
      user = FactoryBot.build(:user, email: "test@example.com")
      expect(user).not_to be_valid
    end
  end

  describe "associações" do
    it "pode ter muitos filmes" do
      user = FactoryBot.create(:user)
      movie1 = FactoryBot.create(:movie, user: user)
      movie2 = FactoryBot.create(:movie, user: user)

      expect(user.movies.count).to eq(2)
    end

    it "pode ter muitos comentários" do
      user = FactoryBot.create(:user)
      movie = FactoryBot.create(:movie)
      comment1 = FactoryBot.create(:comment, user: user, movie: movie)
      comment2 = FactoryBot.create(:comment, user: user, movie: movie)

      expect(user.comments.count).to eq(2)
    end
  end
end
