
import SwiftUI

struct NavigationPush<Destination: View>: ViewModifier {
    let destination: Destination
    
    func body(content: Content) -> some View {
        NavigationPushButton(destination: destination) {
            content
        }
    }
}

struct NavigationPop: ViewModifier {
    
    let destination: PopDestination
    
    func body(content: Content) -> some View {
        NavigationPopButton(destination: destination) {
            content
        }
    }
}

public extension View {
    func navigationPushLink<Destination: View>(
        destination: Destination
    ) -> some View {
        modifier(NavigationPush(destination: destination))
    }
    
    func navigationPopLink(
        destination: PopDestination
    ) -> some View {
        modifier(NavigationPop(destination: destination))
    }
}
