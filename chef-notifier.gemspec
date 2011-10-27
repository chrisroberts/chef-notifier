$LOAD_PATH.unshift File.expand_path(File.dirname(__FILE__)) + '/lib/'
require 'chef-notifier/version'
Gem::Specification.new do |s|
  s.name = 'chef-notifier'
  s.version = ChefNotifier::VERSION.to_s
  s.summary = 'Notifications for Chef'
  s.author = 'Chris Roberts'
  s.email = 'chrisroberts.code@gmail.com'
  s.homepage = 'http://bitbucket.org/chrisroberts/chef-notifier'
  s.description = 'Notifications for Chef'
  s.require_path = 'lib'
  s.extra_rdoc_files = ['README.rdoc', 'CHANGELOG.rdoc']
  s.add_dependency 'mail'
  s.files = %w(LICENSE README.rdoc CHANGELOG.rdoc) + Dir.glob("**/*")
end
