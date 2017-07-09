Puppet::Functions.create_function(:hiera_file) do
  dispatch :lookup_key do
    param 'Variant[String, Numeric]', :key
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def lookup_key(key, options, context)
    unless options.include?('path')
      raise ArgumentError,
        "'hiera_file_lookup_key': one of 'path', 'paths' 'glob', 'globs' or 'mapped_paths' must be declared in hiera.yaml when using this lookup_key function"
    end

    path = File.join(options['path'], key)
    
    if File.exist? path
      return context.cache(key, IO.binread(path))
    end 
    
    context.not_found
  end
end


