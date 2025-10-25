class User < ApplicationRecord
  has_many :movies, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :import_jobs, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
