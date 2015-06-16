# Sample verbose configuration file for Unicorn (not Rack)
#
# This configuration file documents many features of Unicorn
# that may not be needed for some applications. See
# http://unicorn.bogomips.org/examples/unicorn.conf.minimal.rb
# for a much simpler configuration file.
#
# See http://unicorn.bogomips.org/Unicorn/Configurator.html for complete
# documentation.

# Use at least one worker per core if you're on a dedicated server,
# more will usually help for _short_ waits on databases/caches.

#http://sleekd.com/general/configuring-nginx-and-unicorn/
#http://www.rubyrescue.com/blog/2010/06/23/migrating-rails-to-unicorn-from-phusion-passenger/

# Help ensure your application will always spawn in the symlinked
# "current" directory that Capistrano sets up.
# working_directory "/path/to/app/current" # available in 0.94.0+

# listen on both a Unix domain socket and a TCP port,
# we use a shorter backlog for quicker failover when busy
# listen "/tmp/.sock", :backlog => 64
# listen 3000, :tcp_nopush => true

workdir = File.expand_path(File.dirname(__FILE__)+ '/..')
worker_processes 2
working_directory workdir

# This loads the application in the master process before forking
# worker processes
# Read more about it here:
# http://unicorn.bogomips.org/Unicorn/Configurator.html
preload_app true

timeout 30

# This is where we specify the socket.
# We will point the upstream Nginx module to this socket later on
#listen 8080
listen "#{workdir}/tmp/sockets/unicorn.sock", :backlog => 64
pid "#{workdir}/tmp/pids/unicorn.pid"

# Set the path of the log files inside the log folder of the testapp
stderr_path "#{workdir}/log/unicorn.stderr.log"
stdout_path "#{workdir}/log/unicorn.stdout.log"

preload_app true

#GC.respond_to?(:copy_on_write_friendly=) and  GC.copy_on_write_friendly = true

before_fork do |server, worker|
  # Disconnect since the database connection will not carry over
  if defined? ActiveRecord::Base
    ActiveRecord::Base.connection.disconnect!
  end

  # Quit the old unicorn process
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  # Start up the database connection again in the worker
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
  child_pid = server.config[:pid].sub(".pid", ".#{worker.nr}.pid")
  system("echo #{Process.pid} > #{child_pid}")
end

