//
//  ContentView.swift
//  ChickensFarmCrash
//
//  Created by alex on 3/17/25.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var viewModel = WebViewModel(url: URL(string: "https://chickensfarmcrash.top/game")!)
    
    var body: some View {
        GeometryReader { geo in
            WebViewContainer(viewModel: viewModel)
                .onReceive(NotificationCenter.default.publisher(for: .networkStatusChanged)) { notification in
                    if let isConnected = notification.object as? Bool {
                        viewModel.updateNetworkStatus(isConnected)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
        }
        .background(
            
            Color(hex: 0x433F6C)
                .ignoresSafeArea()
        )
    }
}
