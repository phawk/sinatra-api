require "fast_helper"
require_relative "../../app/helpers/json"

RSpec.describe Api::Helpers::Json do
  include Api::Helpers::Json

  it "#true_value?" do
    expect(true_value?(nil)).to be(false)
    expect(true_value?(false)).to be(false)
    expect(true_value?("false")).to be(false)
    expect(true_value?("0")).to be(false)
    expect(true_value?(0)).to be(false)

    expect(true_value?(true)).to be(true)
    expect(true_value?("true")).to be(true)
    expect(true_value?("1")).to be(true)
    expect(true_value?(1)).to be(true)
  end
end
