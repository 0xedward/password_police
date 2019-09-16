# frozen_string_literal: true

module PasswordPolice
  class RoleToPasswordStrengthMap
    attr_reader :role_map

    def initialize(role_map = {})
      raise 'Role map must contain at least one role to password strength pair' if role_map.nil? || role_map.empty?
      raise 'Password strength must be an integer value' if role_map.values.any? { |value| !value.is_a?(Integer) }
      raise 'Password strength must be between 0 and 4' unless role_map_strengths_in_range?(role_map.values)

      @role_map = stringify_keys(role_map)
    end

    def password_strength_fulfilled?(role, user_pwd)
      raise 'Role not found in role_map' if role_map[role].nil?

      PasswordPolice::CalulateStrength.check_strength(user_pwd) >= role_map[role]
    end

    def add_role(role, pwd_strength)
      formatted_role = role.to_s
      raise 'password strength must be between 0 and 4' unless strength_in_range?(pwd_strength)
      raise "#{formatted_role} to password strength mapping already exists" unless role_map[formatted_role].nil?

      role_map[formatted_role] = pwd_strength
      role_map
    end

    def update_role(role, pwd_strength)
      formatted_role = role.to_s
      raise 'password strength must be between 0 and 4' unless strength_in_range?(pwd_strength)
      raise "#{formatted_role} is not found" if role_map[formatted_role].nil?

      role_map[formatted_role] = pwd_strength
      role_map
    end

    def delete_role(role)
      formatted_role = role.to_s
      raise "#{role} is not found" if role_map[formatted_role].nil?

      role_map.delete(formatted_role)
      role_map
    end

    private

    def role_map_strengths_in_range?(strengths)
      strengths.any? { |pwd_strength| strength_in_range?(pwd_strength) }
    end

    def strength_in_range?(pwd_strength)
      (0..4).include?(pwd_strength)
    end

    def stringify_keys(role_map)
      role_map.keys.each do |k|
        raise "duplicate key '#{k}' detected" if role_map.key?(k.to_s)

        role_map[k.to_s] = role_map.delete(k)
      end
      role_map
    end
  end
end
