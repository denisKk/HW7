
import Foundation

final class ArtworkListViewModel<Service: NetworkingService>: ObservableObject {
    internal init(service: Service.Type) {
        self.networkService = service
    }
    
   @Published var artworks: [ArtworkModel] = .init()
   @Published var isLoading: Bool = false
    var page: Int = 1
    let limit: Int = 10
    let networkService: Service.Type
  
    func fetch() {
        guard isLoading == false else { return }
        
        isLoading = true
        networkService.service.fetch(page: page, limit: limit) { [weak self] dataArray in
            self?.isLoading = false
            self?.page += 1
            self?.artworks.append(contentsOf: dataArray)
        }
    }
        
    
    func delete(artwork: ArtworkModel) {
        artworks.removeAll(where: {$0.id == artwork.id})
    }
}
