class EmailValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.nil?

    unless value.match?(/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i)
      record.errors[attribute] << (options[:message] || "is not a valid email address")
    end
  end
end
