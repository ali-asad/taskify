class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :tasks, dependent: :destroy

  has_many :comments, dependent: :destroy

  def admin?
    role == 'admin'
  end
end
