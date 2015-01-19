Pod::Spec.new do |s|
  s.name = 'Funky'
  s.version = '0.1.2'
  s.license = 'WTFPL'
  s.summary = 'Functional programming tools and experiments (in Swift).  Lots of functions.'
  s.authors = { 'bryn austin bellomy' => 'bryn.bellomy@gmail.com' }
  s.license = { :type => 'WTFPL', :file => 'LICENSE.md' }
  s.homepage = 'https://github.com/brynbellomy/Funky'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.source_files = 'src/*.swift', 'src/**/*.swift'
  s.requires_arc = true

  s.dependency 'LlamaKit', '0.1.1'

  s.source = { :git => 'https://github.com/brynbellomy/Funky.git', :tag => s.version }
end
