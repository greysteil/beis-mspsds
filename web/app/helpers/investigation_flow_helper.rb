module InvestigationFlowHelper
  # Commonises report_controller and question_controller
  # xxx in paths can be 'report' or 'question'

  # GET /investigations/xxx/new
  def new
    clear_session
    redirect_to wizard_path(steps.first, request.query_parameters)
  end

  # POST /investigations/xxx
  def create
    load_reporter_and_investigation
    @investigation.reporter = @reporter
    @investigation.source = UserSource.new(user: current_user)
    @investigation.save
    session[:investigation_id] = @investigation.id
  end

  # GET /investigations/xxx
  # GET /investigations/xxx/step
  def show
    load_reporter_and_investigation
    render_wizard
  end

  def load_reporter_and_investigation
    load_investigation
    load_reporter
  end

private

  def load_reporter
    data_from_the_past = session[:reporter] || {}
    data_after_last_step = data_from_the_past.merge(reporter_params)
    session[:reporter] = data_after_last_step
    @reporter = Reporter.new(session[:reporter])
  end

  def reporter_params
    return {} if !params[:reporter].present?

    if params[:reporter][:reporter_type] == 'Other'
      params[:reporter][:reporter_type] = params[:reporter][:other_reporter]
    end
    params.require(:reporter).permit(
      :name, :phone_number, :email_address, :reporter_type, :other_details
    )
  end

  def clear_session
    session[:reporter] = nil
    session[:investigation_id] = nil
  end

  def load_investigation
    # TODO: add loading from params if we use the same flow to edit its details
    @investigation = Investigation.find_by(id: session[:investigation_id]) || default_investigation
  end
end
