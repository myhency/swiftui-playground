//
//  HapticManager.swift
//  Playground
//
//  Created by James on 2023/07/17.
//

import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
}
