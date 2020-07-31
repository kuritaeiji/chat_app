require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'content validation' do
    it { is_expected.to validate_length_of(:content).is_at_most(200) }
  end
end
