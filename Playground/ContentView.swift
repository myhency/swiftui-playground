//
//  ContentView.swift
//  Playground
//
//  Created by James on 2023/07/11.
//

import Combine
import SwiftUI

struct ContentView: View {
    @State var currentTab: Tab = .Home
    @State private var hideTabBar: Bool = false
    @State var translationY: Double = 0.0
    @State var offsetY: Double = 0.0
    @State var velocity: Double = 0.0
    @State var isDragDown = false
    @EnvironmentObject var mainViewModel: MainViewModel
    
    private let screenHeight = UIScreen.main.bounds.height
    
    // Hide Native Bar
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $currentTab) {
            MainView()
                .tag(Tab.Home)
            CoordinateSampleView()
                .tag(Tab.Inventory)
            PlaylistView()
                .tag(Tab.Reward)
        }
        .safeAreaInset(edge: mainViewModel.expandSheet && !isDragDown ? .top : .bottom, content: {
            BottomSheetView(translationY: $translationY, velocity: $velocity)
                .frame(maxWidth: .infinity, maxHeight: mainViewModel.expandSheet
                    ? max(screenHeight - translationY, 0)
                    : 70 + abs(translationY))
                .background(Color.red)
                .offset(y: mainViewModel.expandSheet ? offsetY : -49 - getSafeArea().bottom)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        mainViewModel.expandSheet.toggle()
                    }
                }
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            let translationY = value.translation.height
                            DispatchQueue.global(qos: .userInteractive).async {
                                self.translationY = translationY
                            }
                            if translationY > 0, mainViewModel.expandSheet {
                                isDragDown = true
                            } else if translationY > 0, !mainViewModel.expandSheet {
                                isDragDown = false
                                DispatchQueue.global(qos: .userInteractive).async {
                                    self.translationY = 0.0
                                }
                            }
                        }
                        .onEnded { value in
                            let velocity = value.velocity.height
                            let translationY = value.translation.height
                            self.velocity = velocity
                            
                            /// 339.5
                            let halfPosition = (screenHeight - 55 - (getSafeArea().bottom + getSafeArea().top)) / 2
                            print("transY: \(translationY)")
                            if !mainViewModel.expandSheet, translationY < 0, halfPosition > abs(translationY) {
                                /// expanded 안된 상태에서 사용자가 느리게 drag up 하는 상황, 화면의 절반이상 안올린 경우
                                print("expanded 안된 상태에서 사용자가 느리게 drag up 하는 상황, 화면의 절반이상 안올린 경우")
                                DispatchQueue.main.async {
                                    self.translationY = 0.0
                                }
                            } else if !mainViewModel.expandSheet, translationY < 0, halfPosition <= abs(translationY) {
                                print("expanded 안된 상태에서 사용자가 느리게 drag up 하는 상황, 화면의 절반이상 올린 경우")
                                /// expanded 안된 상태에서 사용자가 느리게 drag up 하는 상황, 화면의 절반이상 올린 경우
                                withAnimation(.easeOut(duration: 0.3)) {
                                    mainViewModel.expandSheet = true
                                }
                                self.translationY = 0.0
                            }
                            
                            if !mainViewModel.expandSheet, translationY > 0 {
                                print("expanded 안된 상태에서 사용자가 drag down 하는 상황")
                                /// expanded 안된 상태에서 사용자가 drag down 하는 상황
                                withAnimation(.easeOut(duration: 0.3)) {
                                    mainViewModel.expandSheet = false
                                }
                                self.translationY = 0.0
                            }
                                    
                            if mainViewModel.expandSheet, translationY > 0, halfPosition > translationY {
                                print("expanded 된 상태에서 사용자가 느리게 drag down 하는 상황, 화면의 절반이상 안내린 경우")
                                /// expanded 된 상태에서 사용자가 느리게 drag down 하는 상황, 화면의 절반이상 안내린 경우
                                DispatchQueue.main.async {
                                    self.translationY = 0.0
//                                    self.offsetY = -5
                                }
                            } else if mainViewModel.expandSheet, translationY > 0, halfPosition <= translationY {
                                print("expanded 된 상태에서 사용자가 느리게 drag down 하는 상황, 화면의 절반이상 내린 경우")
                                /// expanded 된 상태에서 사용자가 느리게 drag down 하는 상황, 화면의 절반이상 내린 경우
                                withAnimation(.easeOut(duration: 0.3)) {
                                    mainViewModel.expandSheet = false
                                    self.translationY = 0.0
                                }
                            }
//
                            if velocity < -700, !mainViewModel.expandSheet {
                                /// 사용자가 빠르게 drag up 하는 상황
                                withAnimation(.easeOut(duration: 0.3)) {
                                    mainViewModel.expandSheet = true
                                }
                            } else if mainViewModel.expandSheet, velocity > 700 {
                                /// 사용자가 빠르게 drag down 하는 상황
                                withAnimation(.easeOut(duration: 0.3)) {
                                    self.translationY = 0.0
                                    mainViewModel.expandSheet = false
                                }
                            }
                        }
                )
        })
        .onChange(of: currentTab, perform: { _ in
            HapticManager.instance.impact(style: .light)
        })
        .onChange(of: mainViewModel.expandSheet, perform: { newValue in
//            DispatchQueue.main.asyncAfter(deadline: .now() + (newValue ? 0.03 : 0.03)) {
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 0.1)) {
                    hideTabBar = newValue
                }
            }
        })
//        .overlay {
//            if mainViewModel.expandSheet {
//                ExpandedSheetView()
//            }
//        }
        .overlay(
            HStack(spacing: 0) {
                ForEach(Tab.allCases, id: \.rawValue) { tab in
                    TabButton(tab: tab)
                        .padding(.vertical)
                }
                .background(Color.white)
            }
            .frame(maxHeight: 55 + getSafeArea().bottom)
            .offset(y: hideTabBar ? 55 + getSafeArea().bottom : 0),
            alignment: .bottom
        )
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    func TabButton(tab: Tab) -> some View {
        GeometryReader { _ in
            Button {
                currentTab = tab
            } label: {
                VStack(spacing: 0) {
                    Image(systemName: tab.rawValue)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(currentTab == tab ? .primary : .secondary)
                        .scaleEffect(currentTab == tab ? 1.1 : 1, anchor: .bottom)
                        .animation(.interpolatingSpring(stiffness: 200, damping: 7).delay(0.1), value: currentTab == tab)
                        .contentShape(Rectangle())
                    
                    Text(tab.tabName).foregroundColor(currentTab == tab ? .primary : .secondary)
                        .font(.caption).padding(.top, 8)
                }
            }
        }
        .frame(height: 45)
    }
}

enum Tab: String, CaseIterable {
    case Home = "house"
    case Inventory = "archivebox"
    case Reward = "bitcoinsign.circle"
    
    var tabName: String {
        switch self {
        case .Home:
            return "Home"
        case .Inventory:
            return "Inventory"
        case .Reward:
            return "Reward"
        }
    }
}

extension View {
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(MainViewModel())
    }
}
