class PicksController < ApplicationController
  def index
    @picks = Pick.all
    @awards = Award.all
  end

  def show
    @pick = Pick.find_by(id: params[:id])
    if @pick.nil?
      flash[:danger] = "Pick does not exist"
  		redirect_to picks_path
    elsif (@pick.is_private) &&  (@pick.user_id != current_user.id)
      flash[:danger] = "Pick is private - Access restricted"
  		redirect_to picks_path
    end
  end

  def new
    @pick = Pick.new
    @players = Player.all
    @teams = Team.all
  end

  def create
    pick_params[:season] = current_season
		@pick = Pick.new(pick_params)
    if logged_in?
  		if @pick.save
  			flash[:success] = "Pick submitted!"
  			redirect_to pick_path(@pick)
  		else
  			render 'new'
  		end
    else
      redirect_to picks_path, :notice => "You must be logged in to make a pick"
    end
	end

  def destroy
    @pick = Pick.find(params[:id])
    @pick.destroy
    redirect_to user_path(current_user), :notice => "Pick successfully deleted."
  end

  def edit
    @pick = Pick.find(params[:id])
  end

  def update
    @pick = Pick.find(params[:id])
    if @pick.update(pick_params)
      redirect_to pick_path(@pick), :notice => "Pick successfully updated."
    else
      render "edit"
    end
  end

  private
  def pick_params
    params.require(:pick).permit(:award_id, :player_id, :user_id, :league_id, :is_private, :season)
  end

  def parse_stats(p_id)
    url = 'http://stats.nba.com/stats/playergamelog?PlayerID=200746&LeagueID=00&Season=2017-18&SeasonType=Regular%20Season'
    headers = {"Accept-Language": "en-us","User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13) AppleWebKit/604.1.38 (KHTML, like Gecko) Version/11.0 Safari/604.1.38","Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", 'referer': 'http://stats.nba.com/'}
    resp = RestClient.get(url, headers = headers )
  end

end
