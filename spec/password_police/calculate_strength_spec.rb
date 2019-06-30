require "rspec"
require "password_police/calculate_strength.rb"

RSpec.describe PasswordPolice::CalculateStrength do
    describe '.check_strength' do
        subject(:strength) { described_class.check_strength(plaintext_pwd) }
    
        context 'password is weak' do
          let(:plaintext_pwd) { 'apple' }
          it { is_expected.to eq(0) }
        end
        
        context 'password is so-so' do
          let(:plaintext_pwd) { '@pplepear' }
          it { is_expected.to eq(1) }
        end 
    
        context 'password is good' do
          let(:plaintext_pwd) { '@pplepearorange' }
          it { is_expected.to eq(2) }
        end
    
        context 'password is strong' do
          let(:plaintext_pwd) { '@pplepearorangepotato' }
          it { is_expected.to eq(3) }
        end           
    
        context 'password is excellent' do
          let(:plaintext_pwd) { '@pplepearorangepotatotomat0' }
          it { is_expected.to eq(4) }
        end           
    
      end
end
