//
//  MainView.swift
//  Playground
//
//  Created by James on 2023/07/13.
//

import SwiftUI

struct MainView: View {
    @State var currentType: String = "Popular"
    @Namespace var animation
    @State var headerOffsets: (CGFloat, CGFloat) = (0, 0)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                HeaderView()
                
                LazyVStack(pinnedViews: [.sectionHeaders], content: {
                    Section {
                        SongList()
                    } header: {
                        PinnedHeaderView()
                            .background(Color.white)
                            .offset(y: headerOffsets.1 > 0 ? 0 : -headerOffsets.1 / 8)
                            .modifier(OffsetModifier(offset: $headerOffsets.0, returnFromStart: false))
                            .modifier(OffsetModifier(offset: $headerOffsets.1))
                    }
                })
            }
        }
        .overlay(content: {
            Rectangle()
                .fill(.white)
                .frame(height: 50)
                .frame(maxHeight: .infinity, alignment: .top)
                .opacity(headerOffsets.0 < 5 ? 1 : 0)
        })
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
    }
    
    @ViewBuilder
    func SongList() -> some View {
        VStack(spacing: 25) {
            ForEach(0 ..< 100) { value in
                Text("Value is \(value)")
                    .font(.title3.bold())
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    func HeaderView() -> some View {
        GeometryReader { proxy in
            /// GeometryReader 의 제일 윗쪽의 y 좌표값, 스크롤을 아래로 내리면 GeometryReader 가 아래로 내려가니까 값이 증가함. 제일 위쪽 값은 0.0
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            /// 아래로 내릴수록 minY 값이 증가하기때문에 height 값도 같이 증가하게 된다.
            let height = (size.height + minY)
//            let height = size.height

            Image("Monkey")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.width, height: height > 0 ? height : 0, alignment: .top)
                .overlay {
                    ZStack(alignment: .bottom) {
                        LinearGradient(colors: [.clear, .black.opacity(0.8)], startPoint: .top, endPoint: .bottom)
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("ARTIST")
                                .font(.callout)
                                .foregroundColor(.gray)
                            
                            HStack(alignment: .bottom, spacing: 10) {
                                Text("Monkey")
                                    .font(.title.bold())
                                    .foregroundColor(.white)
                                
                                Image(systemName: "checkmark.seal.fill")
                                    .foregroundColor(.blue)
                                    .background {
                                        Circle()
                                            .fill(.white)
                                            .padding(3)
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 25)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .cornerRadius(15)
                /// 스크롤을 위로 올리면 minY 값이 음수가 되고 이미지가 위로 올라가게 됨
                .offset(y: -minY)
        }
        .frame(height: 250)
    }
    
    @ViewBuilder
    func PinnedHeaderView() -> some View {
        let types: [String] = ["Popular", "Albums", "Songs", "Fans also like", "About"]
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 25) {
                ForEach(types, id: \.self) { type in
                    VStack(spacing: 12) {
                        Text(type)
                            .fontWeight(.semibold)
                            .foregroundColor(currentType == type ? .black : .gray)
                        
                        ZStack {
                            if currentType == type {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.black)
                                    .matchedGeometryEffect(id: "TAB", in: animation)
                            } else {
                                RoundedRectangle(cornerRadius: 4, style: .continuous)
                                    .fill(.clear)
                            }
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        withAnimation(.easeInOut) {
                            currentType = type
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 25)
            .padding(.bottom, 5)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
