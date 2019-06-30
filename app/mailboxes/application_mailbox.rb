class ApplicationMailbox < ActionMailbox::Base
  routing RepliesMailbox::MATCHER => :replies
  # routing :all => :replies
end
