# test_files/ruby_app/webserver_parser.rb

require 'byebug'
require_relative 'parser_error'

class WebserverParser
	def initialize(file_name)
		@file_name = file_name
	end

	def read_logs
		begin
			visited_pages_hash = find_pages_viwed
			most_visited_pages_hash = {}
			most_unique_pages_hash = {}
			visited_pages_hash.each do |page, ip_addr_hash|
				most_visited_pages_hash[page] = ip_addr_hash.values.sum
				most_unique_pages_hash[page] = ip_addr_hash.keys.uniq.length
			end
			most_visited_pages_arr = most_visited_pages_hash.sort_by {|_key, value| value}.reverse
			most_unique_pages_arr = most_unique_pages_hash.sort_by {|_key, value| value}.reverse
			return [most_visited_pages_arr, most_unique_pages_arr]
		rescue => error
			return [[], []]
		end
	end

	private

	def find_pages_viwed
		visited_pages_hash = {}
		is_valid_file = File.file?(@file_name)
		if is_valid_file
			File.foreach @file_name do |line|
				line = line.split(" ")
				page = line.first
				ip_addr = line.last
				if visited_pages_hash[page].nil?
				   visited_pages_hash[page] = {}
				   visited_pages_hash[page][ip_addr.to_s] = 1
				else
				   visited_pages_hash[page][ip_addr.to_s] = visited_pages_hash[page]["#{ip_addr}"].to_i + 1
				end
			end
		else
			raise ParserError.new('Invalid filename!!')
		end
		visited_pages_hash
	end
end


file_name = 'webserver.log'
parser_obj = WebserverParser.new(file_name)
most_visited_pages_arr, most_unique_pages_arr = parser_obj.read_logs

puts "************List of webpages with most page views*******************\n\n"
most_visited_pages_arr.each do |page|
	puts "#{page[0]} has #{page[1]} visits"
end

puts "\n\n*********List of webpages with most unique page views************"
most_unique_pages_arr.each do |page|
	puts "#{page[0]} #{page[1]} unique views"
end

