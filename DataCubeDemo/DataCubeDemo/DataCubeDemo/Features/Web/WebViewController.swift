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
        static let Bridge = "datacubeBridge"
    }
        
    typealias Reactor = WebViewReactor
    let webView: WKWebView = .init()
    
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
        contentController.add(self, name: Constant.Bridge)
        webView.navigationDelegate = self
        webView.configuration.userContentController = contentController
        
        view.addSubview(webView)
        reactor?.action.onNext(.viewDidLoad(.welcome))
    }
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Logger.info("didStartProvisionalNavigation");
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        Logger.info("didFailProvisionalNavigation")
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        Logger.info("decidePolicyFor WKNavigationAction = \n\(navigationAction)")
        return .allow
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        Logger.info("decidePolicyFor WKNavigationResponse = \n\(navigationResponse)")
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Logger.info("didFinish")
    }
    
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
        Logger.info("userContentController message name = \(message.name)")
        Logger.info("message body = \(message.body)")
//        webView.evaluateJavaScript("receiveMessage('test')")
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
