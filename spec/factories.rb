require "faker"
require "securerandom"
require "active_support/core_ext/integer/time"

FactoryGirl.define do
  to_create(&:save)
end
