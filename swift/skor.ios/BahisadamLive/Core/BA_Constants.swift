//
//  Constants.swift
//  bahisadam
//
//  Created by ilker özcan on 21/09/16.
//  Copyright © 2016 ilkerozcan. All rights reserved.
//

import Foundation

public struct BA_Server {

	public static let BaseUrl = "http://www.bahisadam.com"
	public static let StaticBaseUrl = "http://static.bahisadam.com"
	
	public static let InitialWebviewUrl = BaseUrl + "/bahisadam-ios"
	
	public static let MatchesApi = BaseUrl + "/api/matches/%@/%@/500"
	
	// DEPRECATED: - Navigation
	public static let MatchApi = "/futbol/lig/lig-ios/%d-sezonu/t1-vs-t2/mac-detayi?match_id=%@"
	// DEPRECATED: - Navigation
	public static let MatchStatsApi = "/futbol/lig/lig-ios/%d-sezonu/t1-vs-t2/istatistikler?match_id=%@"
	
	// DEPRECATED: - Navigation
	public static let TeamDetail = "/takim/t1/takim-kadrosu?team_id=%d"
	
	public static let LiveApi = BaseUrl + "/api/live-scores"
	public static let PointsApi = "/lig/stsl-superlig/puan-durumu?league_id=1"
	public static let PointsApi_AZ = "/lig/stsl-superlig/puan-durumu?league_id=81"
	public static let StatsApi = BaseUrl + "/api/league/list"
	public static let StatsDetail = "/lig/lig-ios/ios-istatistikler?league_id=%d"
	public static let PointsDetail = "/lig/lig-ios/puan-durumu?league_id=%d"
	
	// DEPRECATED
	public static let RegisterForPushes = BaseUrl + "/ios/registerforpushes"
	
    public static let MatchDetailApi = BaseUrl + "/api/match/detail/%@"
	public static let UpdateForecastApi = BaseUrl + "/match/updateForecast"
	
	public static let StandingsHomeAwayApi = BaseUrl + "/api/standings/homeaway/%d"
	public static let StandingsApi = BaseUrl + "/api/standings/%d"
	
	public static let GetForecastsApi = BaseUrl + "/api/forecast/match-forecast/list/%@"
	public static let LikeForecastsApi = BaseUrl + "/api/forecast/like/%@"
	public static let ForecastsCommentApi = BaseUrl + "/api/forecast/update-myforecast"
	
	// DEPRECATED: - Navigation
	public static let PlayerApi = BaseUrl + ""
	
	public static let AuthLogin = BaseUrl + "/api/auth/login"
	public static let AuthRegister = BaseUrl + "/api/auth/register"
	public static let DeviceLogin = BaseUrl + "/api/auth/device-login"
    
    public static let AddFavoritesApi = BaseUrl + "/api/user/favorites/add"
    public static let RemoveFavoritesApi = BaseUrl + "/api/user/favorites/remove"
    
    // Side Navigation url
    public static let TahminLigi = BaseUrl + "/tahmin-ligi"
    public static let IddaaBulteni = BaseUrl + "/iddaa-bulteni"
    public static let PrivacyPolicy = BaseUrl + "/gizlilik-sozlesmesi"
    
    // puan durumu
    public static let ScoreStandingsApi = BaseUrl + "/api/league/standings/%d"
    
    // statistic
    public static let StatisticApi = BaseUrl + "/api/stats/byLeague/%d"
}
