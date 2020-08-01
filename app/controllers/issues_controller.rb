class IssuesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :find_issue, only: [:show, :edit, :update, :destroy]

  def index
    @issues = policy_scope(Issue)
    if params[:query].present?
      sql_query = "question ILIKE :query OR tag ILIKE :query"
      @issues = Issue.where(sql_query, query: "%#{params[:query]}%")
    else
      @issues = Issue.all
    end
  end

  def show
    @issues = Issue.all
    @reply = Reply.new
  end

  def new
    @ issue = Issue.new
    @ issue.options.build
    authorize @ issue
  end

  def create
    @issue          = Issue.new(issue_params)
    @issue.category = params["issue"]["category"].to_i
    @issue.user_id  = current_user.id

    authorize @issue

    if @issue.save!
      redirect_to issue_path(@issue)
    else
      render :new
    end
  end

  private

  def find_issue
    @issue = Issue.find(params[:id])
    authorize @issue
  end

  def issue_params
    params.require(:issue).permit(:question, :context, :expired_at, :photo, {options_attributes: [:description]})
  end
end
