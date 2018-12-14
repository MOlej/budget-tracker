class User < ApplicationRecord
  has_many :expenditures, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :name, presence: true, length: { in: 3..30 }
end
