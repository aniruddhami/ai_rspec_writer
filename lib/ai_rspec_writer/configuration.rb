# lib/ai_rspec_writer/configuration.rb
module AiRspecWriter
  class Configuration
    attr_accessor :chatgpt_api_key, :gemini_api_key, :ai_provider, :chatgpt_model, :gemini_model

    def initialize
      @chatgpt_api_key = ENV.fetch("CHATGPT_API_KEY", nil)
      @gemini_api_key = ENV.fetch("GEMINI_API_KEY", nil)
      @ai_provider = ENV.fetch("DEFAULT_AI", "chatgpt")
      @chatgpt_model = ENV.fetch("CHATGPT_MODEL", "o3-mini")
      @gemini_model = ENV.fetch("GEMINI_MODEL", "gemini-2.0-flash")
    end
  end
end
