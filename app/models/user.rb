class User < ActiveRecord::Base
  has_many :fragments

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User
end
