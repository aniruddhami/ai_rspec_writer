# frozen_string_literal: true

require "rails_helper"

RSpec.describe AIRspecWriter::AIProviders::ChatGPTGenerator do
  let(:client) { instance_double(OpenAI::Client) }
  let(:response) do
    {
      "choices" => [
        {
          "message" => {
            "content" => "