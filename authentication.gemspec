Gem::Specification.new do |s|
  s.name    = 'authentication'
  s.version = '1.0.2'
  s.date    = '2008-08-16'
  
  s.summary     = "A rails plugin that handles authentication"
  s.description = "A rails plugin that handles authentication"
  
  s.author   = 'Sean Huber'
  s.email    = 'shuber@huberry.com'
  s.homepage = 'http://github.com/shuber/authentication'
  
  s.has_rdoc = false
  
  s.files = %w(
    CHANGELOG
    init.rb
    lib/authentication.rb
    lib/huberry/authentication/controller_methods.rb
    lib/huberry/authentication/model_methods.rb
    MIT-LICENSE
    Rakefile
    README.markdown)
  
  s.test_files = %w(
    test/_controller_test.rb
    test/_model_test.rb
    test/helpers/table_test_helper.rb
    test/helpers/user_test_helper.rb
    test/init.rb)
end
