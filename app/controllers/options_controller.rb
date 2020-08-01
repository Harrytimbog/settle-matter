class OptionsController < ApplicationController
  def new
    @issue = Issue.find(params[:issue_id])
    @option = Option.new
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @option = Option.new(option_params)
    @option.issue = @issue

    @option.save
  end

  def upvotes
    @option = Option.find(params[:id])
    @option.users.push(current_user)
    authorize @option

    @option.save!
    redirect_to issue_path(@option.issue)
  end

  private

  def option_params
    params.require(:option).permit(:description, :photo)
  end
end
