#!/usr/bin/env ruby
if ARGV.length == 1 then
	s = File.new(ARGV[0], "r")
else
	puts "-- MarioLANG2 --\n"
	puts "Usage: ./mariolang.rb file\n"
	puts "Arguments\n"
	puts "file - Text file containing MarioLANG2 code\n"
	exit 1
end
def elevdir(code, posx, posy)
	0.upto(code.length-1) { |i|
		return 0 if code[i].length < posx
		return (if i < posy then -1 else 1 end) if code[i][posx] == "\""
	}
end
code = []
s.each { |line| code << line }
s.close()
vars = [0]
varl = varp = 0
posx = posy = 0
dirx = 1
diry = 0
elevator = false
skip = 0
loaded_string = ""
recording_str = false
last_stand_still = false
loop {
	if posy < 0 then
		STDERR.print "Error: trying to get out of the program!\n"
		exit 1
	end
	if skip == 0 then
		if not recording_str then
			if not code[posy][posx] == "!" then
				last_stand_still = false
			end
			case code[posy][posx]
				when "\""
					diry = -1
					elevator = false
				when ")"
					varp += 1
					vars << 0 if varp > varl
				when "("
					varp -= 1
					if varp < 0 then
						STDERR.print "Error: trying to access Memory Cell -1\n"
						exit 1
					end
				when "+"
					vars[varp] += 1
				when "-"
					vars[varp] -= 1
				when "."
					print vars[varp].chr
				when ":"
					print "#{vars[varp]} "
				when ","
					vars[varp] = STDIN.getc.ord
				when ";"
					vars[varp] = STDIN.gets.to_i
				when ">"
					dirx = 1
				when "<"
					dirx = -1
				when "^"
					diry = -1
				when "!"
					dirx = diry = 0
					if last_stand_still then
						# Standing still for 2 turns, assume end of program
						exit 0
					else
						last_stand_still = true
					end
				when "["
					skip = 2 if vars[varp] == 0
				when "@"
					dirx = -dirx
				when "%"
					recording_str = false
					loaded_string = ""
				when "*"
					recording_str = true
				when "]"
					recording_str = false
				when "$"
					print "#{loaded_string} "
			end
		else
			if code[posy][posx] == "]" then
				recording_str = false
			else
				loaded_string += code[posy][posx]
			end
		end
	end
  while code[posy][posx].nil?
    code[posy] << " "
  end
	exit 0 if posy == code.length - 1 or posx >= code[posy+1].length
	if "><@".include?(code[posy][posx]) and skip == 0 then
		elevator = false
		diry = 0
		posx += dirx
	elsif diry != 0 then
		skip -= 1 if skip > 0
		posy += diry
		diry = 0 if !elevator
	else
		case code[posy+1][posx]
			when "=", "|", "\""
				posx += dirx
			when "#"
				posx += dirx
				if dirx == 0 and code[posy][posx] == "!" and skip == 0 then
					elevator = true
					diry = elevdir(code, posx, posy)
					if diry == 0 then
						STDERR.print "Error: No matching elevator ending found!\n"
						exit 1
					end
					posy += diry
				end
			else
				posy += 1
		end
		skip -= 1 if skip > 0
	end
}
