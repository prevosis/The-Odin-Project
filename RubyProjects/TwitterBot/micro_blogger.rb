require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts 'Initializing...'
		@client = JumpstartAuth.twitter
	end

	def tweet(message)
		@client.update(message)
	end

	def followers_list
		screen_names = []
		@client.followers.each do |follower|
			screen_names << @client.user(follower).screen_name
		end
		screen_names
	end	

	def dm(target, message)
		puts "Trying to send #{target} this direct message:"
		puts message
		
		if followers_list.include?target
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts 'ERROR: Only people who follow you can receive direct messages.'
		end
	end

	def spam_my_followers(message)
		followers_list.each do |follower|
			dm(follower, message)
		end
	end

	def shorten(url)
		puts "Shortening this url: #{url}" 
	end

	def run
		puts 'Welcome to the JSL Twitter Client!'
		command = ''
		while command != 'q'
			printf 'enter command: '
			input = gets.chomp
			parts = input.split(' ')
			command = parts[0]
			case command
				when 'q'
					puts 'Goodbye!'
				when 't'
					tweet(parts[1..-1].join(' '))
				when 'dm'
					dm(parts[1], parts[2..-1].join(' '))
				when 'spam'
					spam_my_followers(parts[1..-1].join(' '))
				else
					puts "Sorry, I don\'t know how to #{command}"
			end
		end
	end
end

blogger = MicroBlogger.new
blogger.run
