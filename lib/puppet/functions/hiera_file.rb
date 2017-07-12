Puppet::Functions.create_function(:hiera_file) do
  dispatch :data_dig do
    param 'Variant[String, Array[String]]', :key
    param 'Hash', :options
    param 'Puppet::LookupContext', :context
  end

  def data_dig(key, options, context)
    unless options.include?('path')
      raise ArgumentError,
        "'hiera_file_data_dig': 'path' must be declared in hiera.yaml when using this data_dig function"
    end
    
    if key.is_a? String
      filename = key
    else
      filename = key.join('.')
    end

    path = File.join(options['path'], filename)
    
    if File.exist? path
      return context.cache(key, IO.binread(path))
    end 
    
    context.not_found
  end
end
