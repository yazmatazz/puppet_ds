require 'spec_helper'
require 'puppet/type/puppet_ds'

RSpec.describe 'the puppet_ds type' do
  it 'loads' do
    expect(Puppet::Type.type(:puppet_ds)).not_to be_nil
  end
end
