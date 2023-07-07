//
//  WebViewController.swift
//  DataCubeDemo
//
//  Created by Hyunil.Park on 2022/06/16.
//

import WebKit
import RxCocoa
import RxSwift
import ReactorKit

class WebViewController: BaseViewController, StoryboardView {
    
    enum Constant {
        static let userAgentKey = "userAgent"
        static let Bridge = "datacubeBridge"
        static let customUserAgent = "DataCubeInApp"
    }
        
    typealias Reactor = WebViewReactor
    let webView: WKWebView = .init()
    private var webViewList: [WKWebView] = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reactor = Reactor()
        setupUI()
    }

    func bind(reactor: WebViewReactor) {
        reactor.state.map({
            $0.request
        }).distinctUntilChanged().observe(on: MainScheduler.instance).bind(onNext: {
            [unowned self] request in
            guard let request = request else { return }
            self.webView.load(request)
        }).disposed(by: disposeBag)
        
        reactor.state.map({
            $0.addWebViewRequest
        }).distinctUntilChanged().observe(on: MainScheduler.instance).bind(onNext: {
            [unowned self] request in
            guard let request = request else { return }
            self.addWebView(request: request)
        }).disposed(by: disposeBag)
        
        reactor.state.map({
            $0.script
        }).distinctUntilChanged().observe(on: MainScheduler.instance).bind(onNext: {
            [unowned self] script in
            guard let script = script else { return }
            self.callJavaScript(script)
        }).disposed(by: disposeBag)
        
        reactor.state.map({
            $0.scriptWithPgResult
        }).distinctUntilChanged().observe(on: MainScheduler.instance).bind(onNext: {
            [unowned self] script in
            guard let script = script else { return }
            self.callJavaScriptWithPgResult(script)
        }).disposed(by: disposeBag)
    }
}

extension WebViewController {
    private func setupUI() {
        WKWebsiteDataStore.default().httpCookieStore.add(self)
        let statusBarHeight = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame.height ?? .zero
        webView.frame = CGRect(x: .zero,
                               y: statusBarHeight,
                               width: view.bounds.width,
                               height: view.frame.height - statusBarHeight)
        navigationController?.navigationBar.set(isHidden: true, alpha: 1.0)
        let contentController = webView.configuration.userContentController
        let originalUserAgent = webView.value(forKey: Constant.userAgentKey) as? String ?? .empty
        let customUserAgent = "\(originalUserAgent) \(Constant.customUserAgent)"
        contentController.add(self, name: Constant.Bridge)
        webView.navigationDelegate = self
        webView.configuration.userContentController = contentController
        webView.customUserAgent = customUserAgent
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        webViewList.append(webView)
        view.addSubview(webView)
        reactor?.action.onNext(.viewDidLoad(.welcome))
    }
    
    private func addWebView(request: URLRequest) {
        WKWebsiteDataStore.default().httpCookieStore.add(self)
        let webView = WKWebView(frame: webView.frame)
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: Constant.Bridge)
        webView.navigationDelegate = self
        webView.configuration.userContentController = contentController
        webView.load(request)
        view.addSubview(webView)
        webViewList.append(webView)
    }
    
    private func callJavaScript(_ script: String) {
        Logger.debug(script)
    }
    
    private func callJavaScriptWithPgResult(_ script: String) {
        if let webView = webViewList.last {
            webView.removeFromSuperview()
            webViewList.removeLast()
        }
        
        if let webView = webViewList.first {
            webView.evaluateJavaScript(script)
        }
    }
}

extension WebViewController: WKNavigationDelegate {
    
    // 웹뷰 로드 시작
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {    }
    
    // 웹뷰 로드 실패
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        guard let url = navigationAction.request.url else {
            return .cancel
        }
        if url.absoluteString.contains("//itunes.apple.com/") {
            await UIApplication.shared.open(url)
            return .cancel
        }
        if !url.absoluteString.hasPrefix("http://") && !url.absoluteString.hasPrefix("https://") {
            if UIApplication.shared.canOpenURL(url) {
                await UIApplication.shared.open(url)
                return .cancel
            } else {
                Logger.info("UIApplication.shared.can not open URL = \(url)")
            }
        }
        return .allow
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    // 웹뷰 로드 완료
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {    }
}

extension WebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        Logger.info("createWebViewWith configuration = \n\(configuration)")
        Logger.info("navigationAction = \n\(navigationAction)")
        return nil
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        Logger.info("runJavaScriptAlertPanelWithMessage = \n\(message)")
        completionHandler()
    }
}

extension WebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        guard message.name == Constant.Bridge else { return }
        guard let message = message.body as? String else { return }
        reactor?.action.onNext(.receiveScriptMessage(message))
    }
}

extension WebViewController: WKHTTPCookieStoreObserver {
    func cookiesDidChange(in cookieStore: WKHTTPCookieStore) {
        cookieStore.getAllCookies {
            Logger.debug($0)
        }
    }
}

extension WebViewController {
    static func initiate() -> WebViewController {
        let viewController = WebViewController.storyboardViewController()
        return viewController
    }
}
