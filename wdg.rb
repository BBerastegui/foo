require 'socket'
require 'digest/md5'

def init()
	receivefile()
end

def receivefile()
# Server starts 
	server = TCPServer.new("localhost", 2000)
	puts "Server running..."
# Run 4ever
	loop do
	Thread.start(server.accept) do |client|
# Notify the client that party is going to start
		client.puts "[/!\\] Hi. Reading..."
		file = client.read
		puts Time.now.to_f.to_s
		tempname = Time.now.to_f.to_s + ".bin"
		puts "The tempname is: "+tempname
		filehandler = File.open('/tmp/'+tempname, 'w')
		filehandler.write(file)
# Close client connection
		client.puts "Bye bye."
		client.close
# Close file handler
		filehandler.close
		puts "Temp. name: "+tempname
		if (checkduplicate(tempname))
			puts "DUPLICATED !"
		else
			handlefile(tempname)
		end
	end
	end
end

def handlefile(tempname)
	puts "Renaming: "+tempname
	hash = Digest::MD5.hexdigest(File.read(File.open('/tmp/'+tempname,'r')))
	puts hash
	File.rename('/tmp/'+tempname, '/tmp/'+hash+'.bin')
end

def checkduplicate(tempname)
	puts "I'm into tempname()"
	return false
end

def craftconfig()
	
end

#var1 = "testvar1"
#system *%W(echo -n #{var1})
init()
