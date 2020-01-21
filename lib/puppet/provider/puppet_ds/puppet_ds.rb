require 'puppet/resource_api/simple_provider'
require 'puppet/util/puppet_ds/connection'

# Implementation for the puppet_ds type using the Resource API.
class Puppet::Provider::PuppetDs::PuppetDs < Puppet::ResourceApi::SimpleProvider
  def get(context)
    connection = Puppet::Util::PuppetDs::Connection.new(context)
    current_config = connection.config
    return [] if current_config.empty?

    current_config['ensure'] = 'present'
    current_config['name']   = connection.url
    [current_config]
  end

  def create(context, name, should)
    connection = Puppet::Util::PuppetDs::Connection.new(context)
    context.debug("Validating config for '#{name}'")
    data = sanitize_should(should)
    if connection.validate(data)
      connection.config = data
    else
      raise StandardError, "Could not validate RBAC data: #{data}"
    end
  end

  def update(context, name, should)
    create(context, name, should)
  end

  def delete(context, name)
    context.notice("Deleting '#{name}'")
  end

  private

  def sanitize_should(should)
    should.delete(:name)
    should.delete(:ensure)

    # Convert keys to strings
    should.map { |k, v| [k.to_s, v] }.to_h
  end
end
