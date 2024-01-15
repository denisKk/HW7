
import SwiftUI
import UI

@main
struct ArtworksApp: App {
 
    @StateObject var store: Store = .init(database: LocalFiles.service)
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainScreen()
                    .environmentObject(store)
            }
        }
    }
}
