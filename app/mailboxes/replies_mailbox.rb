class RepliesMailbox < ApplicationMailbox
  MATCHER = /reply-(.+)@reply.example.com/i

  before_processing :require_user

  def process
    discussion.comments.create(
      user: user,
      body: mail.decoded,
    )
  end

  private

  def user
    @user ||= User.find_by(email: mail.from)
  end

  def require_user
    unless user
      # Action Mailersを用いて受信メールを送信者に送り返す（bounce back）
      # ここで処理が停止する
      bounce_with UserMailer.missing(inboud_email)
    end
  end

  def discussion
    @discussion ||= Discussion.find(discussion_id)
  end

  def discussion_id
    recipient = mail.recipients.find { |r| MATCHER.match?(r) }
    recipient[MATCHER, 1]
  end
end
