# Add current path and lib to the load path
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

Dir.glob('lib/tasks/*.rake').each { |r| import r }

task default: ["ci:all"]
