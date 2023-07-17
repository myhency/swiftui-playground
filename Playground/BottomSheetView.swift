//
//  BottomSheetView.swift
//  Playground
//
//  Created by James on 2023/07/16.
//

import SwiftUI

struct BottomSheetView: View {
    @Binding var translationY: Double
    @Binding var velocity: Double
    private let screenHeight = UIScreen.main.bounds.height

    var body: some View {
        VStack {
            Text("translationY: \(translationY)")
            Text("velocity: \(velocity)")
            Text("screen Height: \(screenHeight)")
        }
//            .frame(maxWidth: .infinity, minHeight: 70)
//            .background(Color.red)
    }
}

struct BottomSheetView_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView(translationY: .constant(0.1), velocity: .constant(0.2))
    }
}
