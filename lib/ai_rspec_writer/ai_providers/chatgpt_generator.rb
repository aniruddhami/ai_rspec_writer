# frozen_string_literal: true

require "openai"
require "pry"
require "tty-spinner"
require "colorize"

module AIRspecWriter
  module AIProviders
    # Generates RSpec tests using OpenAI's ChatGPT API
    class ChatGPTGenerator
      def initialize(ec: nil, schema: nil)
        @extra_comment = ec
        @schema = schema
        @client = OpenAI::Client.new(access_token: AiRspecWriter.configuration.chatgpt_api_key)
      end

      def generate_spec(file_content)
        my_schema = "check my table defination details: #{@schema}" if @schema

        # puts  "Write RSpec tests for this Ruby code with all factory files and rubocop standards:\n\n#{file_content}\n\n#{@extra_comment}\n\n #{my_schema}"
        
        # Define loading spinner
        spinner = TTY::Spinner.new("[:spinner] Generating AI-powered RSpec tests".yellow, format: :dots)

        # Start the spinner
        spinner.auto_spin

        response = @client.chat(
          parameters: {
            model: AiRspecWriter.configuration.chatgpt_model,
            messages: [{ role: "user", content: "Write RSpec tests for this Ruby code with all factory files and rubocop standards:\n\n#{file_content}\n\n#{@extra_comment}\n\n #{my_schema}" }]
          }
        )

        # Stop the spinner when AI response is ready
        spinner.success("✅ Done!")

        full_content = response.dig("choices", 0, "message", "content")
        
        # extract_ruby_code(full_content)
        full_content
      rescue StandardError => e
        spinner.error("(❌ An error occurred while calling ChatGPT AI: #{e.message})")
        exit 1
      end

      private

      # Extracts Ruby code from AI response
      def extract_ruby_code(text)
        match = text.match(/```ruby\n(.*?)```/m)
        match ? match[1].strip : "Error: No valid Ruby code detected in AI response."
      end
    end
  end
end
