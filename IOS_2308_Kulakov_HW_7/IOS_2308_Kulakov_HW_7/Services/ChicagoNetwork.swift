
import Foundation
import ArtInstituteChicagoNetworking


extension Artwork {
    
    enum ImageSize {
        case small, full
    }
    
    func getURLFromId(size: ImageSize) -> URL {
        let sizeSTR = size == .small ? ",300" : "full"
        return URL(string: "https://www.artic.edu/iiif/2/\(self.imageId ?? self.altImageIds?.first ?? "")/full/\(sizeSTR)/0/default.jpg")!
    }
}

final class ChicagoNetwork: NetworkingService {
    
    class var service: ChicagoNetwork {
        if let service: ChicagoNetwork = ServiceLocator.service() {
            return service
        }
        
        let service = ChicagoNetwork()
        ServiceLocator.addService(service)
        return service
    }
    
    func fetch(page: Int, limit: Int) async -> [ArtworkModel] {
        
        
        let result = try? await ArtworksAPI.everythingGet(page: "\(page)", limit: "\(limit)")
        
        let modelsArray = result?.data?.map {
            ArtworkModel(
                id: $0.id ?? 0,
                title: $0.title ?? "",
                descrittion: $0.description?.htmlToString ?? "",
                imageURL: $0.getURLFromId(size: .small),
                imageFullScreenURL: $0.getURLFromId(size: .full),
                materials: $0.mediumDisplay ?? "",
                author: $0.artistDisplay ?? "" ,
                date: $0.dateDisplay ?? ""
            )
        }
        
        
        return modelsArray ?? []
    }
}
