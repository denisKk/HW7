
import SwiftUI

struct HeaderList: View {
    
    @Binding var selectedTab: Headers
    let layout: AnyLayout
    
    var body: some View {
        ZStack {
            Color.black
            
            TabView(selection: $selectedTab) {
                ForEach(Headers.allCases, id: \.self.rawValue) { item in
                    HeaderCell(title: item.description, logo: item.getLogo, layout: layout)
                        .tag(item)
                        .padding(.bottom, 34)
                }
            }
            .tabViewStyle(.page)
        }
    }
}

struct HeaderList_Previews: PreviewProvider {
    static var previews: some View {
        HeaderList(selectedTab: .constant(.aic), layout: AnyLayout(VStackLayout()))
    }
}

extension HeaderList {
    enum Headers: Int, CaseIterable {
        case cma
        case aic
        case liked
        
        var description: String {
            switch self {
            case .aic:
                return "The Art Institute of Chicago"
            case .cma:
                return "Cleveland Museum of Art"
            case .liked:
                return "Liked Artworks"
            }
        }
        
        var getLogo: Image {
            switch self {
            case .aic:
                return Image("aic")
            case .cma:
                return Image("cma2")
            case .liked:
                return Image(systemName: "star")
            }
        }
    }
}
