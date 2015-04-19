
require './build-tools'


project = loadProject name: 'Funky'

project.addSubmodule 'LlamaKit', globs: ['vendor/LlamaKit/*.swift']
project.save()



