desc "Opens a console session [Development]"
task(:irb) do
  irb = ENV['IRB_PATH'] || 'irb'
  system "#{irb} -r./app.rb"
end
