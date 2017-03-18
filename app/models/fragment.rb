class Fragment < ApplicationRecord
  belongs_to :user
  validates :url, presence: true
  validates_format_of :url, :with => /http/
end
