# frozen_string_literal: true

require 'gemini-ai'
require 'colorize'
require 'tty-spinner'

module AIRspecWriter
  module AIProviders
    # Generates RSpec tests using Google's Gemini AI API
    class GeminiGenerator
      def initialize(ec: nil, schema: nil)
        @extra_comment = ec
        @schema = schema
        @client = Gemini.new(
          credentials: {
            service: 'generative-language-api',
            api_key: AiRspecWriter.configuration.gemini_api_key
          },
          options: { model: AiRspecWriter.configuration.gemini_model, server_sent_events: true }
        )
      end

      def generate_spec(file_content)
        fixed_promt = "Write RSpec tests for this Ruby code with all factory files and rubocop standards:"
        my_schema = "Check my table definition details: #{@schema}" if @schema

        # Define loading spinner
        spinner = TTY::Spinner.new("[:spinner] Generating AI-powered RSpec tests".yellow, format: :dots)

        # Start the spinner
        spinner.auto_spin

        begin
          result = @client.generate_content({
                                              contents: { 
                                                role: "user", 
                                                parts: { 
                                                  text: "#{fixed_promt}\n\n#{file_content}\n\n#{@extra_comment}\n\n#{my_schema}" 
                                                } 
                                              }
                                            })
                                                  
          if result["candidates"].first["content"]["parts"].first["text"].present?
            # Stop the spinner when AI response is ready
            spinner.success("✅ Done!")
            return result["candidates"].first["content"]["parts"].first["text"]
          else
            spinner.error('(Gemini AI returned an empty response.)')
            return nil
          end
        rescue StandardError => e
          spinner.error("(❌ An error occurred while calling Gemini AI: #{e.message})")
          exit 1
        end
      end
    end
  end
end
