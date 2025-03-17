import SwiftUI

struct LoadingScreen: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                
                
                Image(.logo)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                
                Image(.chicken)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width * 0.8)
                
                
                Spacer()
                
                ZStack {
                    // Фоновая обводка с градиентом
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.white.opacity(0.3), .gray.opacity(0.2)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.white, .green.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 2
                                )
                        )
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    
                    // Зеленый прогресс с анимацией
                    Rectangle()
                        .frame(height: 50)
                        .foregroundColor(.clear)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.green, .green.opacity(0.7)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * CGFloat(progress), alignment: .leading)
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 3, x: 0, y: 0)
                }
                .frame(width: geometry.size.width - 40) // Отступы по 20 с каждой стороны
                
                // Текст с улучшенным стилем
                Text("Loading: \(Int(progress * 100))%")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.orange, .yellow],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .orange.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Spacer()
            }
            .frame(width: geometry.size.width)
            .background(
                Image(.background)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
        }
    }
}

#Preview {
    LoadingScreen(progress: 0.75)
}
