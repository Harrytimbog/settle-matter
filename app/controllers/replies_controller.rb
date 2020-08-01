class RepliesController < ApplicationController
  def new
    @issue = Issue.find(params[:issue_id])
    @reply = Reply.new
    authorize @reply
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @reply = Reply.new(reply_params)
    @reply.issue_id = params[:issue_id]
    @reply.user_id = current_user.id
    @reply.owner_id = current_user.id
    authorize @reply
    if @reply.save
      IssueChannel.broadcast_to(
      @issue,
      render_to_string(partial: "display-replies", locals: { reply: @reply })
      )
      respond_to do |format|
        format.html {redirect_to issue_path(@issue)}
        format.js {redirect_to issue_path(@issue)}
      end

    else
      render "issues/show"
    end
  end

  def destroy
    @reply.destroy

    redirect_to issue_path(@issue)
  end

  def mark
    @reply = Reply.find(params[:id])
    @reply.users.push(current_user)
    authorize @reply

    @reply.save!
    redirect_to issue_path(@reply.issue)
  end

  private

  def reply_params
    params.require(:reply).permit(:answer, :reply_votes)
  end
end
