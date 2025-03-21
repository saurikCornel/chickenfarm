//
//  WebView.swift
//  ChickensFarmCrash
//
//  Created by alex on 3/17/25.
//

import Foundation
import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    @ObservedObject var viewModel: WebViewModel
    
    func makeUIView(context: Context) -> WKWebView {
        debugPrint("Creating WKWebView with URL: \(viewModel.url)")
        let configuration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        viewModel.setWebView(webView)
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        debugPrint("Updating WKWebView, current URL: \(uiView.url?.absoluteString ?? "none")")
    }
    
    func makeCoordinator() -> Coordinator {
        debugPrint("Coordinator created")
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        private var isRedirecting = false
        
        init(_ parent: WebView) {
            self.parent = parent
            debugPrint("Coordinator initialized")
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            debugPrint("Navigation started for URL: \(webView.url?.absoluteString ?? "unknown")")
            if !isRedirecting {
                DispatchQueue.main.async { [weak self] in
                    self?.parent.viewModel.loadingState = .loading(progress: 0.0)
                }
            }
        }
        
        func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
            debugPrint("Content started loading, progress: \(Int(webView.estimatedProgress * 100))%")
            isRedirecting = false
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            debugPrint("Navigation finished for URL: \(webView.url?.absoluteString ?? "unknown")")
            DispatchQueue.main.async { [weak self] in
                self?.parent.viewModel.loadingState = .loaded
            }
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            debugPrint("Navigation failed: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.parent.viewModel.loadingState = .failed(error)
            }
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            debugPrint("Provisional navigation failed: \(error.localizedDescription)")
            DispatchQueue.main.async { [weak self] in
                self?.parent.viewModel.loadingState = .failed(error)
            }
        }
        
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .other, webView.url != nil {
                debugPrint("Redirect detected to: \(navigationAction.request.url?.absoluteString ?? "unknown")")
                isRedirecting = true
            }
            decisionHandler(.allow)
        }
    }
}
