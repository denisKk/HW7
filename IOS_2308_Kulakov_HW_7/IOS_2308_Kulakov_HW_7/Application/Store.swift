//
//  Store.swift
//  IOS_2308_Kulakov_HW_4
//
//  Created by Dev on 14.01.24.
//

import Foundation


class Store: ObservableObject {
    
    @Published var likedArtworks: [ArtworkModel] = .init()
    
    init(database: DatabaseService) {
        self.database = database
        loadFromCache()
    }
    
    private let database: DatabaseService
    
    func addArtwork(_ artwork: ArtworkModel) {
        likedArtworks.append(artwork)
        saveToCache()
    }
    
    func removeArtwork(_ artwork: ArtworkModel) {
        likedArtworks.removeAll(where: {$0.id == artwork.id})
        saveToCache()
    }
    
    func contains(by id: Int) -> Bool {
        likedArtworks.contains(where: {$0.id == id})
    }
    
    func loadFromCache() {
        Task {
            let artworks = await database.fetch(source: String(describing: self), page: 0, limit: 0)
            if !artworks.isEmpty {
                await MainActor.run{
                    likedArtworks = artworks
                }
            }
        }
    }
    
    func saveToCache() {
        Task {
            try? await database.save(source: String(describing: self), page: 0, limit: 0, artworks: likedArtworks)
        }
    }
    
}
