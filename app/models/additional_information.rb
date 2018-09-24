class AdditionalInformation < ApplicationRecord
  belongs_to :portfolio

  validates :title, :description, presence: true
  belongs_to :block
  validates :block_id, uniqueness: true
end
