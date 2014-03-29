require 'spec_helper'

describe Moneyball::BattingStat do
  let(:batting_stat) { create(:batting_stat) }
  let(:zero_at_bats) { create(:batting_stat, at_bats: 0) }

  it { should respond_to(:batting_avg) }
  it { should respond_to(:player_birth_year) }
  it { should respond_to(:player_first_name) }
  it { should respond_to(:player_full_name) }
  it { should respond_to(:player_last_name) }
  it { should respond_to(:slugging_percentage) }

  describe "#batting_avg" do
    context "With zero at-bats" do
      it "returns 0.00" do
        expect(zero_at_bats.batting_avg).to eq 0.00
      end
    end

    it "returns a float" do
      expect(batting_stat.batting_avg).to eq 0.347
    end
  end

  describe "#slugging_percentage" do
    context "With zero at-bats" do
      it "returns 0.00" do
        expect(zero_at_bats.slugging_percentage).to eq 0.00
      end
    end

    it "returns a float" do
      expect(batting_stat.slugging_percentage).to eq 0.639
    end
  end


end
