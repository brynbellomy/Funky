Pod::Spec.new do |s|
  s.name = 'Funky'
  s.version = '0.3.0'
  s.summary = 'Functional programming tools and experiments (in Swift).  Lots of functions.'
  s.license = { :type => 'MIT', :file => 'LICENSE.md' }
  s.homepage = 'https://brynbellomy.github.io/Funky'
  s.documentation_url = 'https://brynbellomy.github.io/Funky'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'src/*.swift'
  s.requires_arc = true

  s.dependency 'Regex', '0.3.0'

  s.source = { :git => 'https://github.com/brynbellomy/Funky.git', :tag => s.version }
end
