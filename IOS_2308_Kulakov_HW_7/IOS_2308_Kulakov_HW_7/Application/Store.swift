//
//  Store.swift
//  IOS_2308_Kulakov_HW_4
//
//  Created by Dev on 14.01.24.
//

import Foundation


class Store: ObservableObject {
    
    @Published var likedArtworks: [ArtworkModel] = .init()
    
    
    func addArtwork(_ artwork: ArtworkModel) {
        likedArtworks.append(artwork)
    }
    
    func removeArtwork(_ artwork: ArtworkModel) {
        likedArtworks.removeAll(where: {$0.id == artwork.id})
    }
    
    func contains(by id: Int) -> Bool {
        likedArtworks.contains(where: {$0.id == id})
    }
}
