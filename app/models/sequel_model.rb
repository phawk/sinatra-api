class Sequel::Model
  def self.first_or_initialize(params)
    first(params) || new(params)
  end
end
