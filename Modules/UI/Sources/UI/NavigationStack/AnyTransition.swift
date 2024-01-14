

import SwiftUI

public extension AnyTransition {
    
    static var moveAndFade: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing).combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    static var moveToBottom: AnyTransition {
        AnyTransition.move(edge: .trailing).combined(with: .move(edge: .bottom))
    }
}
