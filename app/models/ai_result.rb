# frozen_string_literal: true

class AiResult < ApplicationRecord
  belongs_to :user
  belongs_to :car
end
