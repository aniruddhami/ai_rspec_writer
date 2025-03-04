# frozen_string_literal: true

require_relative "ai_providers/chatgpt_generator"
require_relative "ai_providers/gemini_generator"
require "pry"

module AIRspecWriter
  # Responsible for handling AI-based test generation
  class Generator
    def initialize(ai: nil, ec: nil, schema: nil)
      @ai = ai.presence || AiRspecWriter.configuration.ai_provider
      @extra_comment = ec
      @schema = schema
    end

    def generate(file_paths)
      file_contents = file_paths.map do |file_path|
        next "Error: File not found (#{file_path})" unless File.exist?(file_path)
        File.read(file_path)
      end.join("\n\n") # Combine multiple files
      
      generator = case @ai.downcase
                  when "chatgpt" then AIProviders::ChatGPTGenerator.new(ec: @extra_comment, schema: @schema)
                  when "gemini" then AIProviders::GeminiGenerator.new(ec: @extra_comment, schema: @schema)
                  else
                    raise "Unsupported AI. Use 'chatgpt' or 'gemini'."
                  end

      generator.generate_spec(file_contents)
    end
  end
end
