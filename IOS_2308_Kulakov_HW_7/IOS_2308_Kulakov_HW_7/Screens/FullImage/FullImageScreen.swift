
import SwiftUI
import UI

struct FullImageScreen: View {
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 1
    
    @State private var offset: CGPoint = .zero
    @State private var lastTranslation: CGSize = .zero
    
    let url: URL
    
    var body: some View {
        
        GeometryReader { proxy in
            ZStack {
                
                image
                    .gesture(makeDragGesture(size: proxy.size))
                    .gesture(makeMagnificationGesture(size: proxy.size))
                
                VStack {
                    CloseButton()
                        .navigationPopLink(destination: .previous)
                    Spacer()
                }
                hint
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
    }
    
    @ViewBuilder
    private var image: some View {
        CacheAsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                VStack {
                    ProgressView()
                    Text("Please wait...")
                }
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
        .scaleEffect(scale)
        .offset(x: offset.x, y: offset.y)
        .edgesIgnoringSafeArea(.all)
    }
    
    @ViewBuilder
    private var hint: some View {
        VStack {
            HStack {
                Image(systemName: "hand.draw.fill")
                Text(" pinch to zoom")
            }
            .font(.subheadline.weight(.bold))
            .padding(.horizontal)
            .foregroundColor(.gray)
        }
        .opacity(scale == 1 ? 1 : 0)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }
    
    private func makeMagnificationGesture(size: CGSize) -> some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / lastScale
                lastScale = value
                
                // To minimize jittering
                if abs(1 - delta) > 0.01 {
                    scale *= delta
                }
            }
            .onEnded { _ in
                lastScale = 1
                if scale < 1 {
                    withAnimation {
                        scale = 1
                    }
                }
                adjustMaxOffset(size: size)
            }
    }
    
    private func makeDragGesture(size: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                let diff = CGPoint(
                    x: value.translation.width - lastTranslation.width,
                    y: value.translation.height - lastTranslation.height
                )
                offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
                lastTranslation = value.translation
            }
            .onEnded { _ in
                adjustMaxOffset(size: size)
            }
    }
    
    private func adjustMaxOffset(size: CGSize) {
        let maxOffsetX = (size.width * (scale - 1)) / 2
        let maxOffsetY = (size.height * (scale - 1)) / 2
        
        var newOffsetX = offset.x
        var newOffsetY = offset.y
        
        if abs(newOffsetX) > maxOffsetX {
            newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
        }
        if abs(newOffsetY) > maxOffsetY {
            newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
        }
        
        let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
        if newOffset != offset {
            withAnimation {
                offset = newOffset
            }
        }
        self.lastTranslation = .zero
    }
}

struct ArtworkFulscreenImageView_Previews: PreviewProvider {
    static var previews: some View {
        FullImageScreen(url: ArtworkModel.testData.last!.imageFullScreenURL)
    }
}
