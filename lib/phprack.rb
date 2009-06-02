class PHPRack

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

    cwd = Dir.pwd

    file = env['PATH_INFO']
    file = 'index.php' if file == '' || file == '/'
    path = File.join(Dir.pwd,file)

    status = File.exist?(path) ? 200 : 404

    cmd = "/usr/local/bin/php -f #{path}"
    puts cmd

    content_type = 'text/html'

    if file =~ /(jpg|gif|png)$/
      if file =~ /jpg$/
        content_type = 'image/jpeg'
      elsif file =~ /gif$/
        content_type = 'image/gif'
      else
        content_type = 'image/png'
      end
    end
    if file =~ /css$/
      content_type = 'text/css'
    end
    
    if file =~ /php$/
      Dir.chdir(File.dirname(path))
      response.body << `#{cmd}`
      Dir.chdir(cwd)
    else
      response.body << File.read(path)
    end

    response.status = status
    response.header.update('Content-Type' => content_type)

    response.finish
  end
end
