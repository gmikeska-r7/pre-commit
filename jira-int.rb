#!/Users/gmikeska/.rvm/rubies/ruby-2.1.5/bin/ruby
#
# This hook script injects ticket references as per Jira in the commit
# message. The hook expects the branch to be formated like so
# type_of_branch/####-description. ### being the reference ticket number.
# If the branch does not reference a ticket number, it will prompt you if
# you want to continue with the commit.

message_file = ARGV[0]
message = File.read(message_file)
branch_name = `git symbolic-ref HEAD 2>/dev/null`
ticket_ref = branch_name[/^refs\/heads\/.+\/MSP\-(\d+)\/.+$/,1]

REGEX = /MSP-\d+/

if message.lines.first.chomp.length > 50
  puts "[ERROR] the first line is longer than 50 charecters"
  puts "\n"
  puts message
  puts "\n"
  exit(1)
end

if !REGEX.match(message)
  if ticket_ref
    message_with_ticket_ref = "#{message.strip}\n\n MSP-#{ticket_ref}"
    File.open(message_file, "w") { |f| f.write "#{message_with_ticket_ref}" }
  else
    puts "[NOTICE] Your branch does not reference a ticket"
    puts "Are you sure (y/n)?"
    exit(1) unless gets.chomp =~ /y|Y/
  end
end
