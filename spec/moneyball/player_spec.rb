require 'spec_helper'

describe Moneyball::Player do
  let(:player) { create(:player) }

  it { should respond_to(:full_name) }

  describe "#full_name" do
    it "returns a concactinated name" do
      expect(player.full_name).to eq "#{player.first_name} #{player.last_name}"
    end
  end
end
