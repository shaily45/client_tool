# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DataStore do

  describe '#load' do
    let(:data_store) { described_class.instance }

    before(:all) do
      DataStore.instance.load('clients.json')
    end
  end
end
