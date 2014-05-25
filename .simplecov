# SimpleCov.maximum_coverage_drop 3

SimpleCov.start do
  command_name 'minitest specs'
  add_filter "/spec/"
  add_filter "/config/"

  add_group 'Helpers', 'app/helpers'
  add_group 'Models', 'app/models'
  add_group 'Mailers', 'app/mailers'
  add_group 'Services', 'app/services'
  add_group 'Routes', 'app/routes'
end
