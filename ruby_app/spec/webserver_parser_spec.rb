require 'rspec'
require 'byebug'
require '../ruby_app/webserver_parser'
require '../ruby_app/parser_error'

describe 'TC_generator' do
  let(:file_name) { "webserver.log"}
  describe 'read log file' do
    context "when invalid filename" do
     it "when invalid filename" do
      parser_obj = WebserverParser.new("demo.log")
      most_visited_pages_arr, most_unique_pages_arr = parser_obj.read_logs
      expect(most_visited_pages_arr).to be_empty
      expect(most_unique_pages_arr).to be_empty
    end
  end  

  context 'when valid filename' do
    before do
      logs =<<-END
      /help_page/1 126.318.035.038
      /contact 184.123.665.067
      /home 184.123.665.067
      /about/2 444.701.448.104
      /help_page/1 126.318.035.038
      /index 444.701.448.104
      /help_page/1 722.247.931.582
      /about 061.945.150.735
      /help_page/1 126.318.035.038
      /home 235.313.352.950
      /contact 184.123.665.067
      /help_page/1 126.318.035.038
      /home 316.433.849.805
      /about/2 444.701.448.104
      /contact 184.123.665.067
      /about 126.318.035.038
      /about/2 836.973.694.403
      /index 316.433.849.805
      /index 802.683.925.780
      /help_page/1 126.318.035.038
      /contact 184.123.665.067
      /about/2 184.123.665.067
      /contact 200.017.277.774
      /about 836.973.694.403  
      /contact 316.433.849.805
      /help_page/1 126.318.035.038
      END
      @file_name = 'test.log'
      File.write(@file_name, logs)
    end

    it 'should check first visited page' do
      parser_obj = WebserverParser.new(@file_name)
      most_visited_pages_arr, most_unique_pages_arr = parser_obj.read_logs
      expect(most_visited_pages_arr.first[0]).to eq('/help_page/1')
      expect(most_visited_pages_arr.first[1]).to eq(7)
    end

    it 'should check last visited page' do
      parser_obj = WebserverParser.new(@file_name)
      most_visited_pages_arr, most_unique_pages_arr = parser_obj.read_logs
      expect(most_visited_pages_arr.last[0]).to eq('/home')
      expect(most_visited_pages_arr.last[1]).to eq(3)
    end

    it 'should check most unique page views' do
      parser_obj = WebserverParser.new(@file_name)
      most_visited_pages_arr, most_unique_pages_arr = parser_obj.read_logs
      expect(most_unique_pages_arr.first[0]).to eq('/about')
      expect(most_unique_pages_arr.first[1]).to eq(3)
    end
  end
end

end