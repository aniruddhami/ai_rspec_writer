# frozen_string_literal: true

require_relative "lib/ai_rspec_writer/version"
Gem::Specification.new do |spec|
  spec.name          = "ai_rspec_writer"
  spec.version       = AiRspecWriter::VERSION
  spec.authors       = ["Aniruddha Mirajkar"]
  spec.email         = ["mirajkaraniruddha@gmail.com"]

  spec.summary       = "A gem to generate RSpec tests using AI (ChatGPT, GeminiAI)."
  spec.description   = "AI-powered RSpec test generator that creates model and controller specs."
  spec.homepage      = "https://github.com/aniruddhami/ai_rspec_writer"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 3.0.0"

  spec.files         = Dir["lib/**/*", "bin/*", "README.md", "LICENSE"]
  spec.bindir        = "bin"
  spec.executables   = ["ai_rspec_writer"]
  spec.require_paths = ["lib"]

  # Dependencies
  spec.add_dependency "rspec-rails", "~> 6.0"
  spec.add_dependency "ruby-openai", "~> 7.3"
  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "tty-spinner", "~> 0.9"
  spec.add_dependency "gemini-ai", "~> 4.2.0"
  spec.add_dependency "dotenv", '~> 3.1'
  
  # Development Dependencies
  spec.add_development_dependency "pry", "~> 0.14.2"
  spec.add_development_dependency "rubocop", "~> 1.50"
  spec.add_development_dependency "rubocop-performance", "~> 1.19"
end
