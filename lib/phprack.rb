class PHPRack

  def call(env)
    request = Rack::Request.new(env)
    response = Rack::Response.new

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
      response.body << File.read(path)
    else
      if file =~ /css$/
        content_type = 'text/css'
      end
      response.body << `#{cmd}`
    end

    response.status = status
    response.header.update('Content-Type' => content_type)

    response.finish
  end
end
