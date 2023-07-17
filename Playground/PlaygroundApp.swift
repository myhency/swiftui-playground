//
//  PlaygroundApp.swift
//  Playground
//
//  Created by James on 2023/07/11.
//

import SwiftUI

@main
struct PlaygroundApp: App {
    @StateObject var mainViewModel = MainViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(mainViewModel)
        }
    }
}
