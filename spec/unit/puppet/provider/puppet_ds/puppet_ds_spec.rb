require 'spec_helper'

ensure_module_defined('Puppet::Provider::PuppetDs')
require 'puppet/provider/puppet_ds/puppet_ds'

RSpec.describe Puppet::Provider::PuppetDs::PuppetDs do
  subject(:provider) { described_class.new }

  let(:context) { instance_double('Puppet::ResourceApi::BaseContext', 'context') }
  let(:connection) { instance_double('Puppet::Util::PuppetDs::Connection') }

  describe '#get' do
    it 'processes resources' do
      example_config = {
        'help_link'                           => 'http://techsmruti.com/online-ldap-test-server/',
        'ssl'                                 => false,
        'group_name_attr'                     => 'name',
        'password'                            => 'password',
        'connect_timeout'                     => 30,
        'user_display_name_attr'              => 'displayName',
        'disable_ldap_matching_rule_in_chain' => true,
        'ssl_hostname_validation'             => true,
        'hostname'                            => 'ldap.forumsys.com',
        'base_dn'                             => 'ou=mathematicians,dc=example,dc=com',
        'user_lookup_attr'                    => 'uid',
        'port'                                => 389,
        'login'                               => 'cn=read-only-admin,dc=example,dc=com',
        'group_lookup_attr'                   => 'ou',
        'group_member_attr'                   => 'member',
        'ssl_wildcard_validation'             => false,
        'user_email_attr'                     => 'mail',
        'user_rdn'                            => 'uid',
        'group_object_class'                  => 'ou',
        'display_name'                        => 'ldap.forumsys.com',
        'search_nested_groups'                => true,
        'start_tls'                           => false,
      }

      allow(Puppet::Util::PuppetDs::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:url).and_return('https://foo:4433')
      allow(connection).to receive(:config).and_return(example_config)

      expect(provider.get(context)).to eq [
        {
          name: 'https://foo:4433',
          ensure: 'present',
          help_link: 'http://techsmruti.com/online-ldap-test-server/',
          ssl: false,
          group_name_attr: 'name',
          password: 'password',
          connect_timeout: 30,
          user_display_name_attr: 'displayName',
          disable_ldap_matching_rule_in_chain: true,
          ssl_hostname_validation: true,
          hostname: 'ldap.forumsys.com',
          base_dn: 'ou=mathematicians,dc=example,dc=com',
          user_lookup_attr: 'uid',
          port: 389,
          login: 'cn=read-only-admin,dc=example,dc=com',
          group_lookup_attr: 'ou',
          group_member_attr: 'member',
          ssl_wildcard_validation: false,
          user_email_attr: 'mail',
          user_rdn: 'uid',
          group_object_class: 'ou',
          display_name: 'ldap.forumsys.com',
          search_nested_groups: true,
          start_tls: false,
        },
      ]
    end
  end

  describe 'create(context, name, should)' do
    it 'creates the resource and validates it' do
      allow(Puppet::Util::PuppetDs::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:url).and_return('https://foo:4433')
      allow(context).to receive(:debug)

      expect(connection).to receive(:validate)
      expect(connection).to receive(:config=).with(
        'help_link' => 'test',
        'group_rdn' => nil,
        'login'     => nil,
        'password'  => nil,
        'user_rdn'  => nil,
      )

      provider.create(context, 'a', name: 'a', ensure: 'present', help_link: 'test')
    end

    it 'allows users to skip validation' do
      allow(Puppet::Util::PuppetDs::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:url).and_return('https://foo:4433')
      allow(context).to receive(:debug)

      expect(connection).to receive(:config=).with(
        'help_link' => 'test',
        'group_rdn' => nil,
        'login'     => nil,
        'password'  => nil,
        'user_rdn'  => nil,
      )

      provider.create(context, 'a', name: 'a', ensure: 'present', help_link: 'test', force: true)
    end
  end

  describe 'update(context, name, should)' do
    it 'updates the resource' do
      # rubocop:disable RSpec/SubjectStub
      expect(provider).to receive(:create).with(context, 'foo', name: 'foo', ensure: 'present')

      provider.update(context, 'foo', name: 'foo', ensure: 'present')
    end
  end

  describe 'delete(context, name)' do
    it 'deletes the resource' do
      allow(Puppet::Util::PuppetDs::Connection).to receive(:new).and_return(connection)
      allow(connection).to receive(:url).and_return('https://foo:4433')
      allow(context).to receive(:debug)

      expect(connection).to receive(:config=).with({})

      provider.delete(context, 'foo')
    end
  end
end
