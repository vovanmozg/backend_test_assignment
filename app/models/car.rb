class Car < ApplicationRecord
  belongs_to :brand
  has_one :ai_result
end
