import SwiftUI
import WebKit

struct WebViewContainer: View {
    @StateObject var viewModel: WebViewModel
    
    init(viewModel: WebViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        debugPrint("WebViewContainer initialized")
    }
    
    var body: some View {
        ZStack {
            WebView(viewModel: viewModel)
                .opacity(viewModel.loadingState == .loaded ? 1 : 0.5)
            
            if case .loading(let progress) = viewModel.loadingState {
                GeometryReader { geo in
                    LoadingScreen(progress: progress)
                    .frame(width: geo.size.width, height: geo.size.height, alignment: .center)
                    .background(Color.black)
                }
            } else if case .failed(let error) = viewModel.loadingState {
                Text("Ошибка: \(error.localizedDescription)")
                    .foregroundColor(.red)
            } else if case .noInternet = viewModel.loadingState {
                Text("Нет интернета")
            }
        }
    }
}
