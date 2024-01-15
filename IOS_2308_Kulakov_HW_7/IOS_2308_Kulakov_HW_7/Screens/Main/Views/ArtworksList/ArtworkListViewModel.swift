
import Foundation

final class ArtworkListViewModel<Service: NetworkingService, Database: DatabaseService>: ObservableObject {
    internal init(service: Service.Type, database: Database.Type) {
        self.networkService = service
        self.databaseService = database
    }
    
    @Published var artworks: [ArtworkModel] = .init()
    @Published var isLoading: Bool = false
    var page: Int = 1
    let limit: Int = 10
    let networkService: Service.Type
    let databaseService: Database.Type
    
    
    func refreshData() {
        Task {[weak self] in
            try? await self?.databaseService.service.clear(source: String(describing: Service.self))
            await self?.clearAllData()
        }
    }
    
    func fetchData() {
        
        guard isLoading == false else { return }
        
        
        Task { [weak self, page, limit] in
            
            guard let self else { return }
            
            await self.showLoading(true)
            
            let cacheData = await self.databaseService.service.fetch(source: String(describing: Service.self), page: page, limit: limit)
            
            guard cacheData.isEmpty else {
                print("Load from CACHE")
                self.page += 1
                await MainActor.run {
                    self.artworks.append(contentsOf: cacheData)
                    self.showLoading(false)
                }
                return
            }
            
            
            let networkData = await self.networkService.service.fetch(page: page, limit: limit)
            
            guard networkData.isEmpty else {
                print("Load from NETWORK")
                self.page += 1
                
                try? await databaseService.service.save(source: String(describing: Service.self), page: page, limit: limit, artworks: networkData)
                
                await MainActor.run {
                    self.artworks.append(contentsOf: networkData)
                    self.showLoading(false)
                }
                
                return
            }
            
            await self.showLoading(false)
        }
    }
    
    @MainActor
    func showLoading(_ show: Bool) {
        isLoading = show
    }
    
    @MainActor
    func clearAllData() {
        artworks.removeAll()
        page = 1
        fetchData()
    }
}
