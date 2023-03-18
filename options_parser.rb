# frozen_string_literal: true

class OptionsParser
  def self.parse
    options = {}
    OptionParser.new do |opt|
      opt.on('-fFILENAME', '--feedback_filename FILENAME') { |o| options[:feedback_filename] = o }
      opt.on('-kFILENAME', '--key_filename FILENAME') { |o| options[:key_filename] = o }
      opt.on('-bNUMBER', '--block_length NUMBER') { |o| options[:block_length] = o.to_i }
      opt.on('-lNUMBER', '--length NUMBER') { |o| options[:length] = o.to_i }
      opt.on('-mENCRYPT|DECRYPT', '--mode ENCRYPT|DECRYPT') { |o| options[:mode] = o }
      opt.on('-h', '--help', 'Prints this help') do
        puts opt
        exit
      end
    end.parse!
    options
  end
end
