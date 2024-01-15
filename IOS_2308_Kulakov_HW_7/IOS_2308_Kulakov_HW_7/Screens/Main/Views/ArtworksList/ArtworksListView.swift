
import SwiftUI
import UI


struct ArtworksList<Service: NetworkingService, Database: DatabaseService>: View {
    
    @StateObject var artworkListVM: ArtworkListViewModel<Service, Database>
    @EnvironmentObject private var store: Store
    
    
    var body: some View {
        
        scrollView
            .onAppear{
                artworkListVM.fetchData()
            }
            .ignoresSafeArea()
            .refreshable {
                artworkListVM.refreshData()
            }
    }
    
    @ViewBuilder
    var scrollView: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(artworkListVM.artworks, id: \.id) { artwork in
                    
                    ArtworkListCell(artwork: artwork)
                    .navigationPushLink(destination: ArtworkScreen(artwork: artwork))
                    .onAppear{
                        if artworkListVM.artworks.isLastElement(artwork) {
                            artworkListVM.fetchData()
                        }
                    }
//                    .transition(.moveToBottom)
    
                }
                if artworkListVM.isLoading {
                    ProgressView()
                }
            }
        }
        
    }
}

struct ArtworskList_Previews: PreviewProvider {
    static var previews: some View {
        ArtworksList<ChicagoNetwork, LocalFiles>(artworkListVM: ArtworkListViewModel(service: ChicagoNetwork.self, database: LocalFiles.self))
    }
}
