//
//  WebViewReactor.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/30.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift
import RxDataSources
import SwiftyUserDefaults

final class WebViewReactor: Reactor {
    
    let initialState = State()
    
    enum LoadType {
        case welcome
        case signup
        case signin
    }
    
    enum WebConstant {
        static let hostURL: String = "http://localhost:8000/landing?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg2OTM1NTgsImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.iwnlS8efgE4ZLEh8TxVkS_-IRx1OEbG8NA5PbtH_d9c"
//        static let hostURL: String = "https://devfs.fingerservice.co.kr/landing?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg2MDcwMjksImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.f9l68qTM_sNjIOikoX2G24RD4hnWiG132QY79SW4yjo"
    }
    
    enum Action {
        case viewDidLoad(LoadType)
        case loadRequest(URLRequest)
    }
    
    enum Mutation {
        case setRequest(URLRequest?)
    }
    
    struct State {
        var request: URLRequest?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .viewDidLoad(type):
            var url: String = .empty
            switch type {
            case .welcome, .signup, .signin:
                url = WebConstant.hostURL
                break
            }
            return .just(load(urlStr: url))
        case let .loadRequest(request):
            return .just(Mutation.setRequest(request))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRequest(request):
            newState.request = request
        }
        
        return newState
    }
    
    private func load(urlStr:String) -> Mutation {
        guard let url = URL(string: urlStr) else { return .setRequest(nil) }
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: TimeInterval(60.0))
        return .setRequest(request)
    }
}
