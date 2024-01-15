
import SwiftUI

struct HeaderCell: View {
    
    let title: String
    let logo: Image
    let layout: AnyLayout
    
    var body: some View {
        layout {
            logo
                .resizable()
                .scaledToFit()
                .frame(width: 70, alignment: .leading)
                .foregroundColor(.red)
                .padding(.horizontal)
            
            Text(title)
                .foregroundColor(.white)
                .font(.system(size: 48, weight: .light))
                .minimumScaleFactor(0.5)
            
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding()
    }
}
