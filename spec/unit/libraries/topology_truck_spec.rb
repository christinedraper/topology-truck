# patterned after helper_publish_spec.rb in delivery-truck

require 'spec_helper'

# rubocop:disable HashSyntax
# rubocop:disable LineLength
aws_machine_template = { :convergence_options => { :bootstrap_proxy => nil, :chef_config => nil, :chef_version => '12.8.1', :install_sh_path => nil }, :bootstrap_options => { :instance_type => nil, :key_name => nil, :security_group_ids => nil }, :ssh_username => nil, :image_id => nil, :use_private_ip_for_ssh => nil }
ssh_machine_template = { :convergence_options => { :bootstrap_proxy => nil, :chef_config => nil, :chef_version => '12.8.1', :install_sh_path => nil }, :transport_options => { :username => 'vagrant', :ssh_options => { :user => 'vagrant', :password => 'vagrant', :keys => [] }, :options => { :prefix => nil } } }
# rubocop:enable HashSyntax
# rubocop:enable LineLength

describe TopologyTruck::ConfigParms do
  let(:node) { Chef::Node.new }

  shared_examples_for 'Pipelines --- Stages --- Topologies --- and more ... ' do
    context 'Check all the config.json options...' do
      it 'PIPELINE details? [pl_level?]' do
        expect(tp_trk_parms.pl_level?).to eql(pl_level)
      end

      it 'STAGE details? [st_level?]' do
        expect(tp_trk_parms.st_level?).to eql(st_level)
      end

      it 'TOPOLOGY details? [tp_levels?]' do
        expect(tp_trk_parms.tp_level?).to eql(tp_level)
      end

      it 'check for aws driver at pipeline level [pl_driver]' do
        expect(tp_trk_parms.pl_driver).to eql(driver)
      end

      it 'check for driver type at pipeline level [pl_driver_type]' do
        expect(tp_trk_parms.pl_driver_type).to eql(driver_type)
      end

      it 'machine_options' do
        expect(tp_trk_parms.machine_options).to eql(template_mach_opts)
      end

      it 'pl_machine_options' do
        expect(tp_trk_parms.pl_machine_options).to eql(pl_machine_options)
      end

      it 'st_topologies(verify)' do
        # rubocop:disable LineLength
        expect(tp_trk_parms.st_topologies('verify')).to eql([{ 'none_specified_for_stage' => 'verify' }])
        # rubocop:enable LineLength
      end

      it 'st_topologies(build)' do
        # rubocop:disable LineLength
        expect(tp_trk_parms.st_topologies('build')).to eql([{ 'none_specified_for_stage' => 'build' }])
        # rubocop:enable LineLength
      end

      it 'st_topologies(acceptance)' do
        expect(tp_trk_parms.st_topologies('acceptance')).to eql(a_tps)
      end

      it 'st_topologies(union)' do
        expect(tp_trk_parms.st_topologies('union')).to eql(u_tps)
      end

      it 'st_topologies(rehearsal)' do
        expect(tp_trk_parms.st_topologies('rehearsal')).to eql(r_tps)
      end

      it 'st_topologies(delivered)' do
        expect(tp_trk_parms.st_topologies('delivered')).to eql(d_tps)
      end

      it 'st_driver_type(acceptance)' do
        expect(tp_trk_parms.st_driver_type('acceptance')).to eql(a_drv)
      end

      it 'st_driver_type(union)' do
        expect(tp_trk_parms.st_driver_type('union')).to eql(u_drv)
      end

      it 'st_driver_type(rehearsal)' do
        expect(tp_trk_parms.st_driver_type('rehearsal')).to eql(r_drv)
      end

      it 'st_driver_type(delivered)' do
        expect(tp_trk_parms.st_driver_type('delivered')).to eql(d_drv)
      end

      it 'pl_topologies' do
        expect(tp_trk_parms.pl_topologies).to eql(pl_tps)
      end
    end
  end

  describe 'topology-truck: { }' do
    raw_data = {
      'topology-truck' => {}
    }

    let(:pl_level) { false }
    let(:st_level) { false }
    let(:tp_level) { false }
    let(:driver) { '_unspecified_' }
    let(:driver_type) { '_unspecified_' }
    let(:template_mach_opts) { {} }
    let(:pl_machine_options) { {} }
    let(:a_tps) { [] }
    let(:u_tps) { [] }
    let(:r_tps) { [] }
    let(:d_tps) { [] }
    let(:a_drv) { '_unspecified_' }
    let(:u_drv) { '_unspecified_' }
    let(:r_drv) { '_unspecified_' }
    let(:d_drv) { '_unspecified_' }
    let(:pl_tps) { [] }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe 'all levels empty' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {},
        'stages' => {},
        'topologies' => {}
      }
    }

    let(:pl_level) { true }
    let(:st_level) { true }
    let(:tp_level) { true }
    let(:driver) { '_unspecified_' }
    let(:driver_type) { '_unspecified_' }
    let(:template_mach_opts) { {} }
    let(:pl_machine_options) { {} }
    let(:a_tps) { [] }
    let(:u_tps) { [] }
    let(:r_tps) { [] }
    let(:d_tps) { [] }
    let(:a_drv) { '_unspecified_' }
    let(:u_drv) { '_unspecified_' }
    let(:r_drv) { '_unspecified_' }
    let(:d_drv) { '_unspecified_' }
    let(:pl_tps) { [] }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe '.simple aws driver for pipeline' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {
          'driver' => 'aws'
        }
      }
    }

    let(:pl_level) { true }
    let(:st_level) { false }
    let(:tp_level) { false }
    let(:driver) { 'aws' }
    let(:driver_type) { 'aws' }
    let(:template_mach_opts) { aws_machine_template }
    let(:pl_machine_options) { {} }
    let(:a_tps) { [] }
    let(:u_tps) { [] }
    let(:r_tps) { [] }
    let(:d_tps) { [] }
    let(:a_drv) { 'aws' }
    let(:u_drv) { 'aws' }
    let(:r_drv) { 'aws' }
    let(:d_drv) { 'aws' }
    let(:pl_tps) { [] }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe 'simple ssh driver for pipeline' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {
          'driver' => 'ssh'
        }
      }
    }

    let(:pl_level) { true }
    let(:st_level) { false }
    let(:tp_level) { false }
    let(:driver) { 'ssh' }
    let(:driver_type) { 'ssh' }
    let(:template_mach_opts) { ssh_machine_template }
    let(:pl_machine_options) { {} }
    let(:a_tps) { [] }
    let(:u_tps) { [] }
    let(:r_tps) { [] }
    let(:d_tps) { [] }
    let(:a_drv) { 'ssh' }
    let(:u_drv) { 'ssh' }
    let(:r_drv) { 'ssh' }
    let(:d_drv) { 'ssh' }
    let(:pl_tps) { [] }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe 'simple ssh driver for pipeline' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {
          'driver' => 'aws'
        },
        'stages' => {}
      }
    }

    let(:pl_level) { true }
    let(:st_level) { true }
    let(:tp_level) { false }
    let(:driver) { 'aws' }
    let(:driver_type) { 'aws' }
    let(:template_mach_opts) { aws_machine_template }
    let(:pl_machine_options) { {} }
    let(:a_tps) { [] }
    let(:u_tps) { [] }
    let(:r_tps) { [] }
    let(:d_tps) { [] }
    let(:a_drv) { 'aws' }
    let(:u_drv) { 'aws' }
    let(:r_drv) { 'aws' }
    let(:d_drv) { 'aws' }
    let(:pl_tps) { [] }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe 'all stages have one topology' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {
          'driver' => 'aws'
        },
        'stages' => {
          'acceptance' => { 'topologies' => ['a'] },
          'union' => { 'topologies' => ['u'] },
          'rehearsal' => { 'topologies' => ['r'] },
          'delivered' => { 'topologies' => ['d'] }
        }
      }
    }

    let(:pl_level) { true }
    let(:st_level) { true }
    let(:tp_level) { false }
    let(:driver) { 'aws' }
    let(:driver_type) { 'aws' }
    let(:template_mach_opts) { aws_machine_template }
    let(:pl_machine_options) { {} }
    let(:a_tps) { ['a'] }
    let(:u_tps) { ['u'] }
    let(:r_tps) { ['r'] }
    let(:d_tps) { ['d'] }
    let(:a_drv) { 'aws' }
    let(:u_drv) { 'aws' }
    let(:r_drv) { 'aws' }
    let(:d_drv) { 'aws' }
    let(:pl_tps) { %w(a u r d) }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end

  describe 'all stages have one topology' do
    raw_data = {
      'topology-truck' => {
        'pipeline' => {
          'driver' => 'aws'
        },
        'stages' => {
          'acceptance' => {
            'topologies' => ['a'],
            'driver' => 'ssh'
          },
          'union' => {
            'topologies' => ['u'],
            'driver' => 'aws'
          },
          'rehearsal' => {
            'topologies' => ['r'],
            'driver' => 'ssh'
          },
          'delivered' => {
            'topologies' => ['d'],
            'driver' => 'aws'
          }
        }
      }
    }

    let(:pl_level) { true }
    let(:st_level) { true }
    let(:tp_level) { false }
    let(:driver) { 'aws' }
    let(:driver_type) { 'aws' }
    let(:template_mach_opts) { aws_machine_template }
    let(:pl_machine_options) { {} }
    let(:a_tps) { ['a'] }
    let(:u_tps) { ['u'] }
    let(:r_tps) { ['r'] }
    let(:d_tps) { ['d'] }
    let(:a_drv) { 'ssh' }
    let(:u_drv) { 'aws' }
    let(:r_drv) { 'ssh' }
    let(:d_drv) { 'aws' }
    let(:pl_tps) { %w(a u r d) }

    let(:tp_trk_parms) { TopologyTruck::ConfigParms.new(raw_data) }

    it_behaves_like 'Pipelines --- Stages --- Topologies --- and more ... '
  end
end
