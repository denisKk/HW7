//
//  FileManager.swift
//  IOS_2308_Kulakov_HW_7
//
//  Created by Dev on 15.01.24.
//

import Foundation


final class LocalFiles: DatabaseService {

    
    class var service: LocalFiles {
        if let service: LocalFiles = ServiceLocator.service() {
            return service
        }
        
        let service = LocalFiles()
        ServiceLocator.addService(service)
        return service
    }
    
    private static func cacheDirectory() throws -> URL {
        try FileManager.default.url(for: .documentDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
    }
    
    private static func fileURL(with name: String) throws -> URL {
        try Self.cacheDirectory()
            .appendingPathComponent("\(name).data")
    }
    
    func fetch(source: String, page: Int, limit: Int) async -> [ArtworkModel] {
        let fileName = "\(source)_\(page)_\(limit)"
        
        let task = Task<[ArtworkModel], Error> {
            let fileURL = try Self.fileURL(with: fileName)
            guard let data = try? Data(contentsOf: fileURL) else {
                return []
            }
            let dataArray = try JSONDecoder().decode([ArtworkModel].self, from: data)
            return dataArray
        }
        let artworks = try? await task.value
        return artworks ?? []
    }
    
    func save(source: String, page: Int, limit: Int, artworks: [ArtworkModel]) async throws {
        
        let fileName = "\(source)_\(page)_\(limit)"
        
        let task = Task {
            let data = try JSONEncoder().encode(artworks)
            let outfile = try Self.fileURL(with: fileName)
            try data.write(to: outfile)
        }
        _ = try await task.value
    }
    
    func clear(source: String) async throws {
        let task = Task {
            let fileManager = FileManager.default
            let directory = try Self.cacheDirectory()
            let contents = try fileManager.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            
            for file in contents {
                if file.lastPathComponent.contains(source) {
                    try? fileManager.removeItem(atPath: file.path())
                }
            }
        }
            _ = try await task.value
        }
}
