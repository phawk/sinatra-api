require "dry-validation"

EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

UserCreateValidator = Dry::Validation.Form do
  required(:name).maybe
  required(:email).filled(format?: EMAIL_REGEX)
  required(:password).filled(min_size?: 8)
end
