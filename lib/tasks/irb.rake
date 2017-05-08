desc "Opens a console session [Development]"
task(:irb) do
  irb = ENV["IRB_PATH"] || "irb"
  system "#{irb} -r./config/boot.rb"
end
