require_relative 'lib/version'

Gem::Specification.new do |spec|
  spec.name        = 'sapphire-chess'
  spec.version     = SapphireChess::VERSION
  spec.summary     = 'Command line-based chess game'
  spec.description = <<-EOF
    Sapphire Chess is a command line-based chess game with an algebraic notation input system,
    complete chess rules, a beautiful interface and a functional AI. It provides three game modes: 
    Human vs. Human, Human vs. Ai, and AI vs. AI.
  EOF
  spec.authors     = ['Lucas Sorribes']
  spec.email       = 'lucas.sorribes@gmail.com'
  spec.license     = 'MIT'
  spec.homepage    = 'https://github.com/lucsorr/sapphire-chess'
  spec.files       = Dir['**/*'] + %w(Gemfile LICENSE Rakefile sapphire-chess.gemspec)
  spec.bindir      = 'bin'
  spec.executables << 'sapphire-chess'
  spec.required_ruby_version = '>= 2.7.5'
  spec.extra_rdoc_files = ['README.md']

  spec.add_dependency 'paint', '>= 2.3'

  spec.add_development_dependency 'rubocop', '~> 1.43'
end