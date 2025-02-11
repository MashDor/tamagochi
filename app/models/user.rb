class User < ApplicationRecord
  has_one :pet, dependent: :destroy
end
