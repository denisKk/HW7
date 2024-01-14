//
//  LikedList.swift
//  IOS_2308_Kulakov_HW_4
//
//  Created by Dev on 14.01.24.
//

import SwiftUI

struct LikedList: View {
    
    @EnvironmentObject private var store: Store
    
    var body: some View {
        scrollView
            .ignoresSafeArea()
    }
    
    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(store.likedArtworks) { artwork in
                    ArtworkListCell(artwork: artwork)
                        .navigationPushLink(
                            destination: ArtworkScreen(artwork: artwork)
                        )
                        .transition(.slide)
                }
            }
        }
        
    }
}

struct LikedList_Previews: PreviewProvider {
    static var previews: some View {
        LikedList()
    }
}
