//
//  CacheAsyncImage.swift
//  TestHW2
//
//  Created by Dev on 8.10.23.
//

import SwiftUI

public struct CacheAsyncImage<Content>: View where Content: View {

    private let id: String?
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    public init(
        id: String? = nil,
        url: URL,
        scale: CGFloat = 1.0,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.id = id
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {

        if let cached = ImageCache[id] {
            content(.success(cached))
        } else if let disk = ImageCache.loadFromDisk(id: id) {
            content(.success(disk))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction
            ) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }

    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[id] = image
        }

        return content(phase)
    }
}



fileprivate class ImageCache {
    static private var cache: [String: Image] = [:]
        
    private static func cacheDirectory() throws -> URL {
        try FileManager.default.url(for: .cachesDirectory,
                                    in: .userDomainMask,
                                    appropriateFor: nil,
                                    create: false)
    }
    
    private static func fileURL(id: String) throws -> URL {
        try Self.cacheDirectory()
            .appendingPathComponent("\(id).png")
    }

    static subscript(id: String?) -> Image? {
        get {
            guard let id else {return nil}
            return ImageCache.cache[id]
        }
        set {
            guard let id else { return }
            Self.cache[id] = newValue
            if let image = newValue {
                Self.saveOnDisk(id: id, image: image)
            }
        }
    }
    
    fileprivate static func loadFromDisk(id: String?) -> Image? {
        guard let id else { return nil }
        guard let fileURL = try? Self.fileURL(id: id) else { return nil }
        guard let data = try? Data(contentsOf: fileURL) else { return nil }
        guard let uiImage = UIImage(data: data) else { return nil }
        let image = Image(uiImage: uiImage)
        ImageCache[id] = image
        return image
    }
    
    @MainActor static func render(image: Image) -> UIImage? {
        let renderer = ImageRenderer(content:image)
        return renderer.uiImage
    }
    
    fileprivate static func saveOnDisk(id: String, image: Image) {
        Task {
            guard let fileURL = try? Self.fileURL(id: id) else { return }
            guard let uiImage = await render(image: image) else { return }
            guard let data = uiImage.jpegData(compressionQuality: 0.6) else { return }
            try? data.write(to: fileURL)
        }
    }
    
}
