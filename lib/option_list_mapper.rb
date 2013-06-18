class OptionListMapper
	#simple should return array of hashes {:key => value}
	#list should return array of one dimensional hashes that the value is an array {:key => [value, value]}
	#optionally list may return a value that is a hash that will be converted to simple or list
	attr_accessor :modified_options
	def initialize(options_list,kvs,singles,opts)
		options = opts.dup
		@modified_options = options_list
		kvs.each do |key| 
			next if options[key].nil?
			OptionListMapper.map_to_string(@modified_options, key, options[key])
			@modified_options << ' '
		end
		@modified_options << singles.map{|key| OptionListMapper.map_single(key, options[key])}.join(' ')
	end

	class << self

		def create_options(options_list="",kvs=[],singles=[],opts={})
			new(options_list,kvs,singles,opts).modified_options.strip
		end
		
		def map_to_string(string, key, value, display_brackets=true, display_key=true)
			string << "#{key}=" if display_key
			if not value.is_a?(Array) and not value.is_a?(Hash)
				string << value.to_s
			elsif value.is_a?(Array)
				string << '{' if display_brackets
				value.each_with_index{|v, index|
					if v.is_a?(Array)
						map_to_string(string, key, v, true, false)
					elsif v.is_a?(Hash)
						map_to_string(string, key, v, false, false)
					else
						string << v.to_s
					end
					string << ' ' unless index == value.size - 1
				}
				string << '}' if display_brackets
			elsif value.is_a?(Hash)
				string << '{' if display_brackets
				map_to_string(string, value.keys.first, value.values.first)
				string << '}' if display_brackets
			end
			string
		end

		def map_single(key, value)
			return '' if value.nil?
			"#{key} #{value}"
		end

	end
	
end