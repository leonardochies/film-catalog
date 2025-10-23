require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe "validações" do
    it "é válido com conteúdo e associações" do
      comment = FactoryBot.build(:comment)
      expect(comment).to be_valid
    end

    it "é inválido sem conteúdo" do
      comment = FactoryBot.build(:comment, content: nil)
      expect(comment).not_to be_valid
    end

    it "é inválido sem filme" do
      comment = FactoryBot.build(:comment, movie: nil)
      expect(comment).not_to be_valid
    end
  end

  describe "associações" do
    it "pertence a um filme" do
      comment = FactoryBot.create(:comment)
      expect(comment.movie).to be_present
      expect(comment.movie).to be_a(Movie)
    end

    it "pode pertencer a um usuário" do
      comment = FactoryBot.create(:comment)
      expect(comment.user).to be_present
      expect(comment.user).to be_a(User)
    end

    it "pode ser anônimo" do
      comment = FactoryBot.build(:comment, :anonymous)
      expect(comment.user).to be_nil
      expect(comment.author_name).to be_present
    end
  end
end
