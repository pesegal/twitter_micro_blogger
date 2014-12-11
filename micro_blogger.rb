require 'jumpstart_auth'

class MicroBlogger
	attr_reader :client

	def initialize
		puts "Initializing.. :)"
		@client = JumpstartAuth.twitter

	end

	def tweet(message)
		if message.length <= 140
			@client.update(message)
		else
			puts "Warning message cannot be longer then 140 characters. Current length: #{message.length} characters"
		end
	end

	def dm(target, message)
		screen_names = @client.followers.collect { |follower| @client.user(follower).screen_name }
		puts "Trying to send #{target} this direct message:"
		puts message

		if screen_names.include?(target)
			message = "d @#{target} #{message}"
			tweet(message)
		else
			puts "Sorry you can only pm people who follow you."
		end
	end

	def followers_list
		screen_names = []
		@client.followers.each { |follower| screen_names << @client.user(follower).screen_name}
		screen_names
	end

	def spam_my_followers(message)
		follower_list = followers_list
		follower_list.each {|follower| dm(follower,message)}
	end

	def everyones_last_tweet
		friends = @client.friends
		friends.each do |friend|
			puts "#{friend.id} said at #{friend.status.created_at}"
			puts "#{friend.status.source}"
			puts ""
		end
	end

	def run
		puts "Welcome to the JSL Twitter Client!"
		command = ""
		while command != "q"
			printf "enter command:"
			input = gets.chomp
			parts = input.split(" ")
			command = parts[0]


			case command
				when 'q' then puts "Goodbye!"
				when 't' then tweet(parts[1..-1].join(" "))
				when 'dm' then dm(parts[1], parts[2..-1].join(" "))
				when 'spam' then spam_my_followers(parts[1..-1].join(" "))
				when 'elt' then everyones_last_tweet
				else
				puts "Sorry, I don't know how to do #{command}"
			end

		end
	end

	
end

blogger = MicroBlogger.new
blogger.run