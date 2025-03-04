require_relative "ai_rspec_writer/configuration"
require_relative "ai_rspec_writer/version"
require_relative "ai_rspec_writer/generator"
require_relative "ai_rspec_writer/spec_file_handler"
require_relative "ai_rspec_writer/constants"
require "colorize"

module AiRspecWriter
  class Error < StandardError; end
  class << self
    attr_accessor :configuration
    
    def configuration
      @configuration ||= Configuration.new
    end
  end
end

env_file = File.expand_path(".env", Dir.pwd)
if File.exist?(env_file)
  # Load environment variables from .env file
  require "dotenv"
  Dotenv.load(env_file)
end

# ✅ Ensure configuration is initialized
AiRspecWriter.configuration