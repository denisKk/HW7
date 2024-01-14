
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


final class ArtInstituteChicagoNetworkService: NetworkingService {
   
    class var service: ArtInstituteChicagoNetworkService {
        if let service: ArtInstituteChicagoNetworkService = ServiceLocator.service() {
            return service
        }
        
        let service = ArtInstituteChicagoNetworkService()
        ServiceLocator.addService(service)
        return service
    }

    func fetch(page: Int, limit: Int, completion: @escaping ([ArtworkModel]) -> ()) {
       
        ArtworksAPI.everythingGet(page: "\(page)", limit: "\(limit)") { result, error in
            
            guard error == nil else {
                print(error as Any)
                return
            }
            
            if let array = result?.data?.filter({ items in
                items.imageId != nil || items.altImageIds?.first != nil
                
            }) {
         
                let modelsArray = array.map {
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
                completion(modelsArray)
            }
        }
    }
}
