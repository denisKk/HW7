
import SwiftUI
import UI

struct ArtworkListCell: View {
    
    @EnvironmentObject private var store: Store
    
    var artwork: ArtworkModel
    
    var body: some View {
        
        image
        .overlay {
            ZStack(alignment: .bottomTrailing) {
                title
                likeButton
            }
        }
        .padding(.horizontal,4)
        .background(.black)
    }
    
    
    
    @ViewBuilder
    private var title: some View {
        VStack {
            Text(artwork.title)
                .font(.largeTitle.weight(.light))
                .foregroundColor(.white)
                .minimumScaleFactor(0.5)
                .lineLimit(2)
                .padding(4)
                .shadow(color: .black, radius: 2, x: 1, y: 1)
                .frame(maxWidth: .infinity)
                .frame(height: 90)
                .background(
                    Rectangle()
                        .fill(
                            LinearGradient(colors: [.brown, .brown.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                        )
                        .blur(radius: 3)
                )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    private var image: some View {
        CacheAsyncImage(id: "\(artwork.id)", url: artwork.imageURL, transaction: .init(animation: .easeInOut)) { phase in
            
            switch phase {
            case .empty:
                Rectangle()
                    .fill(.clear)
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                
            case .failure(let error):
                Rectangle()
                    .fill(.black)
                    .frame(maxWidth: .infinity)
                    .scaledToFit()
                    .overlay {
                        Text(error.localizedDescription)
                    }
            @unknown default:
                fatalError()
            }
        }
    }
    
    
    @ViewBuilder
    private var likeButton: some View {
        Button {
            withAnimation {
                if store.contains(by: artwork.id) {
                    store.removeArtwork(artwork)
                } else {
                    store.addArtwork(artwork)
                }
            }
        } label: {
            Image(systemName: store.contains(by: artwork.id) ? "heart.fill" : "heart")
                .resizable()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.red, .black)
                .frame(width: 30, height: 30)
                .shadow(radius: 3)
                .padding()
        }
        .padding()
    }
    
    func imageDimenssions(url: URL) -> String{
        if let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) {
            if let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as Dictionary? {
                let pixelWidth = imageProperties[kCGImagePropertyPixelWidth] as! Int
                let pixelHeight = imageProperties[kCGImagePropertyPixelHeight] as! Int
                return "Width: \(pixelWidth), Height: \(pixelHeight)"
            }
        }
        return "None"
    }
}

struct ArtworkListCell_Previews: PreviewProvider {
    static var previews: some View {
        //                ArtworkListCell(artwork: ArtworkListModel.testData.last!){}
        ArtworksList(artworkListVM: ArtworkListViewModel(service: ChicagoNetwork.self, database: LocalFiles.self))
    }
}
