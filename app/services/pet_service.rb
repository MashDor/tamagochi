class PetService
  class << self
    def create_pet(user)
      raise PetAlreadyExistsError if user.current_pet

      Pet.create!(user: user)
    end
  end
end
