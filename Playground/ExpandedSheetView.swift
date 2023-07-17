//
//  ExpandedSheetView.swift
//  Playground
//
//  Created by James on 2023/07/17.
//

import SwiftUI

struct ExpandedSheetView: View {
    @EnvironmentObject var mainViewModel: MainViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: mainViewModel.expandSheet ? .infinity : 0)
            .background(.blue)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.3)) {
                    mainViewModel.expandSheet = false
                }
            }
    }
}

//struct ExpandedSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandedSheetView()
//    }
//}
