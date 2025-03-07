//
//  MainGameView.swift
//  memorygame
//
//  Created by Palamoni, Nikhil Palamoni on 3/6/25.
//
import SwiftUI

struct MainGameView: View {
    @StateObject var gameViewModel = CardGameViewModel()
    @State private var isLandscape = UIDevice.current.orientation.isLandscape
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.blue.opacity(0.1).ignoresSafeArea()
                
                if isLandscape {
                    HStack(spacing: 0) {
                        LazyHGrid(
                            rows: [GridItem(.adaptive(minimum: 100), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(gameViewModel.cards) { card in
                                CardView(gameViewModel: gameViewModel, card: card)
                                    .frame(width: 80, height: 120)
                            }
                        }
                        .padding(.vertical, 12)
                        .padding(.horizontal)
                        .frame(width: geo.size.width * 0.7)
                        
                        ControlPanel(gameViewModel: gameViewModel)
                            .padding()
                            .frame(width: geo.size.width * 0.3)
                    }
                } else {
                    VStack(spacing: 0) {
                        LazyVGrid(
                            columns: [GridItem(.adaptive(minimum: 80), spacing: 16)],
                            spacing: 16
                        ) {
                            ForEach(gameViewModel.cards) { card in
                                CardView(gameViewModel: gameViewModel, card: card)
                                    .frame(height: 120)
                            }
                        }
                        .padding()
                        .frame(height: geo.size.height * 0.72)
                        
                        ControlPanel(gameViewModel: gameViewModel)
                            .padding()
                            .frame(height: geo.size.height * 0.28)
                    }
                }
            }
            .onRotate { orientation in
                // Disable reverse portrait
                if orientation == .portraitUpsideDown {
                    let forced = UIInterfaceOrientation.portrait.rawValue
                    UIDevice.current.setValue(forced, forKey: "orientation")
                } else {
                    withAnimation(.spring()) {
                        isLandscape = orientation.isLandscape
                    }
                }
            }
        }
    }
}

struct OrientationReader: ViewModifier {
    let action: (UIDeviceOrientation) -> Void
    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(
                NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
            ) { _ in
                action(UIDevice.current.orientation)
            }
    }
}

extension View {
    func onRotate(perform action: @escaping (UIDeviceOrientation) -> Void) -> some View {
        modifier(OrientationReader(action: action))
    }
}
