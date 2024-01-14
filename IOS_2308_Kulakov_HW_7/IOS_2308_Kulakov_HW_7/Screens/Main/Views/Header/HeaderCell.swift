
import SwiftUI

struct HeaderCell: View {
    
    let title: String
    let logo: Image
    
    var body: some View {
        HStack {
            logo
                .resizable()
                .scaledToFit()
                .foregroundColor(.red)
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .light))
                .minimumScaleFactor(0.5)
                .padding()
        }
    }
}
