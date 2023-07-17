//
//  DragGesture+Extensions.swift
//  Playground
//
//  Created by James on 2023/07/17.
//

import SwiftUI


extension DragGesture.Value {
    /// Returns Velocity of Drag Gesture (Which is not available in SwiftUI)
    internal var velocity: CGSize {
        let valueMirror = Mirror(reflecting: self)
        for valueChild in valueMirror.children {
            if valueChild.label == "velocity" {
                let velocityMirror = Mirror(reflecting: valueChild.value)
                for velocityChild in velocityMirror.children {
                    if velocityChild.label == "valuePerSecond" {
                        if let velocity = velocityChild.value as? CGSize {
                            return velocity
                        }
                    }
                }
            }
        }
        fatalError("Unable to retrieve velocity from \(Self.self)")
    }

}

