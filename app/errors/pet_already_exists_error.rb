class PetAlreadyExistsError < ApplicationError
  def message
    "pet with same user_id already exists"
  end
end
