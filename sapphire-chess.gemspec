require_relative 'lib/sapphire-chess/version'

Gem::Specification.new do |spec|
  spec.name        = 'sapphire-chess'
  spec.version     = SapphireChess::VERSION
  spec.summary     = 'Command line-based chess game'
  spec.description = <<-EOF
    Sapphire Chess is a command line-based chess game with an algebraic notation input system,
    complete chess rules, a beautiful interface, and a functional AI. It provides three game modes:
    Human vs. Human, Human vs. AI, and AI vs. AI.
  EOF
  spec.authors     = ['Lucas Sorribes']
  spec.email       = 'lucas.sorribes@gmail.com'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/devluxor/sapphire-chess'
  spec.files       = Dir['lib/**/*.rb'] + %w[Gemfile Gemfile.lock LICENSE Rakefile sapphire-chess.gemspec CHANGELOG.md]
  spec.bindir      = 'bin'
  spec.executables << 'sapphire-chess'

  spec.extra_rdoc_files = ['README.md']

  spec.required_ruby_version = '>= 2.7.5'

  spec.add_dependency 'paint', '~> 2.3'
  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop', '~> 1.43'
end
