require "dry-validation"

PasswordValidator = Dry::Validation.Form do
  required(:password).filled(min_size?: 8)
end
