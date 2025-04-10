# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ClientTool do
  let(:client_tool) { described_class.new }

  describe '#run' do
    it 'prompts user for options' do
      allow(client_tool).to receive(:gets).and_return("1")
      expect { client_tool.run }.not_to raise_error
    end
  end
end
