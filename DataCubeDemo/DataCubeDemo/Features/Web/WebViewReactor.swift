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
        static let hostURL: String = "http://localhost:8000/landing?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg3NzU1OTcsImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.O8srBVZGHR65isyvFerM83h5Rk25r4I85a7t3xH-72g"
//        static let hostURL: String = "https://devfs.fingerservice.co.kr?groupCd=10001&token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJkZGFuZ3lvQDEiLCJleHAiOjE2ODg3NzU1OTcsImJpel9yZWdfbm8iOiIxMjA4NjE1ODgxIn0.O8srBVZGHR65isyvFerM83h5Rk25r4I85a7t3xH-72g"
    }
    
    enum DatacubeService: String, Codable {
        case PGRequest = "pgRequest"
        case PGCallback = "pgCallback"
        case PGResultMessage = "pgResultMessage"
    }
    
    enum PaymentResultType: String, Codable {
        case success = "success"
        case fail = "fail"
        case cancel = "cancel"
    }
    
    struct DataCubeScriptMessage: Codable {
        let service: DatacubeService
        let parameter: String
    }
    
    enum Action {
        case viewDidLoad(LoadType)
        case loadRequest(URLRequest)
        case receiveScriptMessage(String)
    }
    
    enum Mutation {
        case setRequest(URLRequest?)
        case addWebView(URLRequest?)
        case callScript(String?)
        case callScriptWithPgResult(String?)
    }
    
    struct State {
        var request: URLRequest?
        var addWebViewRequest: URLRequest?
        var script: String?
        var scriptWithPgResult: String?
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
        case let .receiveScriptMessage(message):
            return .just(receiveScriptMessage(message: message))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .setRequest(request):
            newState.request = request
        case let .addWebView(request):
            newState.addWebViewRequest = request
        case let .callScript(script):
            newState.script = script
        case let .callScriptWithPgResult(script):
            newState.scriptWithPgResult = script
        }
        return newState
    }

}

extension WebViewReactor {
    private func load(urlStr:String) -> Mutation {
        guard let url = URL(string: urlStr) else { return .setRequest(nil) }
        let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: TimeInterval(60.0))
        return .setRequest(request)
    }
    
    private func receiveScriptMessage(message: String) -> Mutation {
        Logger.debug("receiveScriptMessage = \(message)")
        guard let jsonData = message.data(using: .utf8) else {
            fatalError("JSON data convert Failed")
        }
        do {
            let decoder = JSONDecoder()
            let message = try decoder.decode(DataCubeScriptMessage.self, from: jsonData)
            switch message.service {
            case .PGRequest:
                guard let url = URL(string: message.parameter) else { return .addWebView(nil)}
                let request = URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData)
                return .addWebView(request)
            case .PGCallback:
                let script = "\(DatacubeService.PGResultMessage)('\(message)')"
                return .callScriptWithPgResult(script)
            case .PGResultMessage: break
            }
        }catch {
            Logger.error(error)
        }
        return .callScriptWithPgResult(nil)
    }
}



