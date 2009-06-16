Given /^there [are|is] (\d+) fix[es]?$/ do |num|

end

Given /^there is a couple of pre-determined fixes$/ do
  @predetermined = ["Global Warming", "North Korea", "Screaming children"]
  user = User.insert(:ip => "127.0.0.1")
  for text in @predetermined
    fix = Fix.insert(:text => text, :votes_count => 1)
    FixesUser.insert(:user_id => user, :fix_id => fix)
  end
end

Then /^I should see a predetermined fix$/ do
  @predetermined.any? { |text| response.body.include?(text) }.should be_true
end

Then /^I go to the last fix$/ do
  @fix = Fix.order("id DESC").first
  get "#{@fix[:id]}"
end