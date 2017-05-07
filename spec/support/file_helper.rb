module FileHelper
  def read_fixture_file(path)
    File.read(File.expand_path(File.join(__dir__, "..", "fixtures", path)))
  end
end

RSpec.configure do |config|
  config.include FileHelper
end
