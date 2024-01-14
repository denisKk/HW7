
import SwiftUI
import UI

struct ArtworkScreen: View {
    let artwork: ArtworkModel
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                if proxy.size.height > proxy.size.width {
                    verticalView
                } else {
                    horizontalView
                }
                
                VStack {
                    CloseButton()
                        .navigationPopLink(destination: .previous)
                    
                    Spacer()
                }
            }
            .statusBarHidden(true)
        }
    }
}

extension ArtworkScreen {
    
    @ViewBuilder
    var horizontalView: some View {
        HStack {
            image
                .frame(maxWidth: 330, maxHeight: .infinity)
            
            ScrollView {
                table
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder
    var verticalView: some View {
        ScrollView {
            VStack {
                image
                table
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    @ViewBuilder
    var image: some View {
        CacheAsyncImage(url: artwork.imageURL) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
            case .failure(let error):
                Text("Error: \(error.localizedDescription)")
            @unknown default:
                fatalError()
            }
        }
        .frame(minWidth: 330, maxHeight: 400)
        .navigationPushLink(destination: FullImageScreen(url: artwork.imageFullScreenURL))
        .overlay {
            HStack(alignment: .bottom) {
                Image(systemName: "hand.tap")
                Text("tap image for full size")
                    .lineLimit(1)
            }
            .font(.subheadline.weight(.bold))
            .padding(.horizontal)
            .background(.gray.opacity(0.85))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(edges: .bottom)
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    
    
    @ViewBuilder
    var table: some View {
        VStack {
            Text(artwork.title)
                .font(.title.weight(.bold))
                .multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .padding(.bottom)
            
            TableRow(title: "Author", text: artwork.author)
            
            TableRow(title: "Date", text: artwork.date)
            
            TableRow(title: "Medium", text: artwork.materials)
            
            if !artwork.descrittion.isEmpty {
                TableRow(title: "Description", text:  artwork.descrittion, isVertical: true, divider: false)
            }
            
        }
        .padding(.trailing, 24)
        .padding(.leading)
        .foregroundColor(.white)
    }
}

struct TableRow: View {
    let title: String
    let text: String
    var isVertical: Bool = false
    var divider: Bool = true
    var body: some View {
        VStack {
            if isVertical {
                VStack(alignment: .leading) {
                    stack
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                HStack {
                    stack
                }
            }
            if divider {
                Divider()
                    .background(.red)
            }
        }
    }
    
    @ViewBuilder
    var stack: some View {
        Text(title)
            .foregroundColor(.red)
        Text(text)
            .font(.title3.weight(.regular))
            .multilineTextAlignment(.leading)
            .padding(.trailing, 24)
            .padding(.leading)
            .foregroundColor(.white)
        Spacer()
    }
}


struct ArtworkScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArtworkScreen(artwork: ArtworkModel.testData.last!)
    }
}
