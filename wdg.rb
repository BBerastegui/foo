require 'socket'
require 'digest/sha1'

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
	handlefile(tempname)
end
end
end

def handlefile(tempname)
hash = Digest::SHA1.hexdigest(File.read(File.open('/tmp/'+tempname,'r')))
puts hash
if (checkduplicate(hash))
	puts "DUPLICATED !"
	File.delete('/tmp/'+tempname)
else
	puts "Not duplicated, renaming..."
	File.rename('/tmp/'+tempname, '/tmp/'+hash+'.bin')
end
end

def checkduplicate(hash)
puts "I'm into checkduplicate()"
puts "Looking for " + hash + ".bin"
puts Dir.entries("/tmp/").class
Dir.entries("/tmp/").each do |e|
	puts e.class
	puts "File: " + e
	if e.eql? hash+".bin"
		puts "checkduplicate() says: DUPLICATED. Returning true."
		return true
	end
end
return false
end

def craftconfig()
	
end

#var1 = "testvar1"
#system *%W(echo -n #{var1})
init()
