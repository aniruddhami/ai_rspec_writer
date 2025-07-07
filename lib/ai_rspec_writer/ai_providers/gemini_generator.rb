# frozen_string_literal: true

require 'net/http'
require 'json'
require 'uri'
require 'colorize'
require 'tty-spinner'

module AIRspecWriter
  module AIProviders
    # Generates RSpec tests using Google's Gemini AI API
    class GeminiGenerator
      BASE_URL = 'https://generativelanguage.googleapis.com/v1beta/models'
      
      def initialize(ec: nil, schema: nil)
        @extra_comment = ec
        @schema = schema
        @api_key = AiRspecWriter.configuration.gemini_api_key
        @model = AiRspecWriter.configuration.gemini_model
        
        validate_configuration
      end

      def generate_spec(file_content)
        fixed_prompt = "Write RSpec tests for this Ruby code with all factory files and rubocop standards:"
        my_schema = "Check my table definition details: #{@schema}" if @schema

        # Define loading spinner
        spinner = TTY::Spinner.new("[:spinner] Generating AI-powered RSpec tests".yellow, format: :dots)

        # Start the spinner
        spinner.auto_spin

        begin
          content_text = build_content_text(fixed_prompt, file_content, my_schema)
          response_text = call_gemini_api(content_text)
          
          if response_text&.strip&.length&.positive?
            # Stop the spinner when AI response is ready
            spinner.success("✅ Done!")
            return response_text
          else
            spinner.error('(Gemini AI returned an empty response.)')
            return nil
          end
        rescue StandardError => e
          spinner.error("(❌ An error occurred while calling Gemini AI: #{e.message})")
          exit 1
        end
      end

      private

      def validate_configuration
        raise ConfigurationError, "Gemini API key is required" if @api_key.nil? || @api_key.empty?
        raise ConfigurationError, "Gemini model is required" if @model.nil? || @model.empty?
      end

      def build_content_text(fixed_prompt, file_content, my_schema)
        content_parts = [fixed_prompt, file_content, @extra_comment, my_schema].compact
        content_parts.join("\n\n")
      end

      def call_gemini_api(content_text)
        url = build_api_url
        payload = build_payload(content_text)
        
        response = make_http_request(url, payload)
        parse_response(response)
      end

      def build_api_url
        "#{BASE_URL}/#{@model}:generateContent?key=#{@api_key}"
      end

      def build_payload(content_text)
        {
          contents: [
            {
              role: "user",
              parts: [
                { text: content_text }
              ]
            }
          ],
          generationConfig: {
            temperature: 0.7,
            topK: 40,
            topP: 0.95,
            maxOutputTokens: 8192
          }
        }
      end

      def make_http_request(url, payload)
        uri = URI(url)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.read_timeout = 60 # Set timeout for long responses
        
        request = Net::HTTP::Post.new(uri)
        request['Content-Type'] = 'application/json'
        request.body = payload.to_json
        
        response = http.request(request)
        
        unless response.is_a?(Net::HTTPSuccess)
          raise ApiError, "HTTP #{response.code}: #{response.body}"
        end
        
        response
      end

      def parse_response(response)
        data = JSON.parse(response.body)
        
        if data['error']
          raise ApiError, "API error: #{data['error']['message']}"
        end
        
        # Extract the generated text following the same pattern as your original code
        candidates = data['candidates']
        return nil if candidates.nil? || candidates.empty?
        
        first_candidate = candidates.first
        content = first_candidate['content']
        return nil if content.nil?
        
        parts = content['parts']
        return nil if parts.nil? || parts.empty?
        
        parts.first['text']
      rescue JSON::ParserError => e
        raise ApiError, "Failed to parse response: #{e.message}"
      end

      class ApiError < StandardError; end
      class ConfigurationError < StandardError; end
    end
  end
end