require 'spec_helper'
describe 'supervisor' do
  context 'with default values for all parameters' do
    it { should contain_class('supervisor') }
  end
end
