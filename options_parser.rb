# frozen_string_literal: true

class OptionsParser
  def self.parse
    options = {}
    OptionParser.new do |opt|
      opt.on('-fFILENAME', '--feedback_filename FILENAME') do |o|
        options[:feedback_filename] = o
      end
      opt.on('-kFILENAME', '--key_filename FILENAME') do |o|
        options[:key_filename] = o
      end
      opt.on('-bNUMBER', '--block_length NUMBER') { |o| options[:block_length] = o.to_i }
      opt.on('-lNUMBER', '--length NUMBER') do |o|
        options[:length] = o.to_i
      end

      opt.on('-h', '--help', 'Prints this help') do
        puts opt
        exit
      end
    end.parse!
    options
  end
end
