require File.join(File.expand_path(File.dirname(__FILE__)), "spec_helper") 

describe OptionListMapper do
	it "maps simple key value pair" do
		OptionListMapper.map_to_string("",:password, 'test').should eq("password=test")
	end

	it "maps option with array" do
		OptionListMapper.map_to_string("", :boxsize, [10,20]).should eq("boxsize={10 20}")
	end

	it "maps option with an option" do
		OptionListMapper.map_to_string("", :fill, {area: 'table'}).should eq("fill={area=table}")
	end

	it "maps option with an array of options" do
		OptionListMapper.map_to_string("", :fill, [{area: 'table'}, {fillcolor: ['rgb', 1, 0, 0]}]).should eq("fill={area=table fillcolor={rgb 1 0 0}}")
	end

	it "maps singles and kvs correctly" do
		opts = {user_password: 'test', master_password: 'testing', permissions: ['nomodify', 'nocopy'], random: 'text'}
		kvs = [:user_password, :master_password, :permissions]
		singles = [:random, :text]
		OptionListMapper.create_options("", kvs,singles,opts).should eq("user_password=test master_password=testing permissions={nomodify nocopy} random text")
	end

	it "maps a hash" do
		opts =  { dpi: 288, boxsize: [ 100, 100 ] , position: 'center', fitmethod: 'meet' }
		key_values = [:dpi, :boxsize, :position, :fitmethod]
		OptionListMapper.create_options('', key_values, [], opts).should eq("dpi=288 boxsize={100 100} position=center fitmethod=meet")
	end


end