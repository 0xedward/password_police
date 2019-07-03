# frozen_string_literal: true

require 'rspec'
require 'password_police/role_to_password_strength_map.rb'

RSpec.describe PasswordPolice::RoleToPasswordStrengthMap do
  describe '#initialize' do
    subject(:create_role_map_class) { described_class.new(role_map) }

    context 'role_map is empty' do
      let(:role_map) { nil }

      it 'raises an error' do
        expect { create_role_map_class }.to raise_error(
          'Role map must contain at least one role to password strength pair'
        )
      end
    end

    context 'role in role_map contains password strength requirement out of range' do
      let(:role_map) { { admin: 5 } }

      it 'raises an error' do
        expect { create_role_map_class }.to raise_error('password strength must be between 0 and 4')
      end
    end

    context 'role_map contains correct setup' do
      let(:role_map) { { admin: 4, averagejoe: 0 } }

      it 'creates a role_to_password_strength_map instance' do
        expect(create_role_map_class.role_map).to eq(role_map)
      end
    end

    context 'role_map contains the same string as a key and symbol' do
      let(:role_map) { { admin: 4, averagejoe: 0, 'admin' => 7 } }

      it 'raises an error' do
        expect { create_role_map_class }.to raise_error("duplicate key 'admin' detected")
      end
    end
  end

  describe '#add_role' do
    subject(:add_role_to_map) { role_map_class.add_role(role, pwd_strength) }
    let(:role_map_class) { described_class.new(role_map) }
    let(:role_map) { { admin: 4 } }

    context 'role_map contains the role already' do
      let(:role) { :admin }
      let(:pwd_strength) { 4 }
      it 'raises an error' do
        expect { add_role_to_map }.to raise_error("#{role} to password strength mapping already exists")
      end
    end

    context 'role_map does not contain the role already' do
      let(:role) { :user }

      context 'the password strength requirement is out of range' do
        let(:pwd_strength) { 6 }
        it 'raises an error' do
          expect { add_role_to_map }.to raise_error('password strength must be between 0 and 4')
        end
      end

      context 'the password strength requirement is in range' do
        let(:pwd_strength) { 2 }
        it 'add the role correctly' do
          expect(add_role_to_map).to eq('admin' => 4, 'user' => 2)
        end
      end
    end
  end

  describe '#update_role' do
    subject(:update_role_in_map) { role_map_class.update_role(role, pwd_strength) }
    let(:role_map_class) { described_class.new(role_map) }
    let(:role_map) { { admin: 3 } }

    context 'role_map does not contains the role' do
      let(:role) { :user }
      let(:pwd_strength) { 4 }
      it 'raises an error' do
        expect { update_role_in_map }.to raise_error("#{role} is not found")
      end
    end

    context 'role_map contains the role already' do
      let(:role) { :admin }

      context 'the password strength requirement is out of range' do
        let(:pwd_strength) { 9 }
        it 'raises an error' do
          expect { update_role_in_map }.to raise_error('password strength must be between 0 and 4')
        end
      end

      context 'the password strength requirement is in range' do
        let(:pwd_strength) { 4 }
        it 'update the role correctly' do
          expect(update_role_in_map).to eq('admin' => 4)
        end
      end
    end
  end

  describe '#delete_role' do
    subject(:delete_role_in_map) { role_map_class.delete_role(role) }
    let(:role_map_class) { described_class.new(role_map) }
    let(:role_map) { { admin: 3 } }

    context 'role_map does not contains the role' do
      let(:role) { :user }
      it 'raises an error' do
        expect { delete_role_in_map }.to raise_error("#{role} is not found")
      end
    end

    context 'role_map contains the role already' do
      let(:role) { :admin }
      it 'delete the role correctly' do
        expect(delete_role_in_map).to eq({})
      end
    end
  end

  # TODO: fix single or double quotes https://github.com/rubocop-hq/ruby-style-guide#consistent-string-literals
end
