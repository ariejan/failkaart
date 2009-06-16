require 'models'
Fix.all.each do |fix|
  fix.update(:text => fix[:text] + " will be")
end