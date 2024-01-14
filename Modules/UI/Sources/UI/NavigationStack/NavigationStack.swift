

import SwiftUI

final public class NavigationStackViewModel: ObservableObject {
    
    @Published fileprivate var screenStack: ScreenStack = .init()
    
    var easing: Animation = .easeInOut(duration: 0.5)

    // MARK: - API
    
    func push<S: View>(_ screen: S) {
        
        let screen: Screen = .init(id: UUID().uuidString,
                                   nextScreen: AnyView(screen))
        
        withAnimation(easing) {
            screenStack.push(screen)
        }
    }
    
    func pop(to: PopDestination) {
        withAnimation(easing) {
            switch to {
            case .previous:
                screenStack.popToPrevious()
            case .root:
                screenStack.popToRoot()
            }
        }
    }
}


public struct NavigationStack<Content>: View where Content: View {
    
    @StateObject var viewModel: NavigationStackViewModel = .init()
    
    private let content: Content
    
    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        let isRoot = viewModel.screenStack.screens.isEmpty
        //        _ = Self._printChanges()
        return ZStack {
            content
                .environmentObject(viewModel)
                .transition(.moveAndFade)
                .opacity(isRoot ? 1 : 0)
            
            ForEach(viewModel.screenStack.screens) {screen in
                screen.nextScreen
                    .environmentObject(viewModel)
                    .transition(.moveAndFade)
                    .opacity(screen.id == viewModel.screenStack.screens.last?.id ? 1 : 0)
            }
        }
    }
}


public struct NavigationPushButton<Content, Destination>: View where Content: View, Destination: View {
    
    @EnvironmentObject var viewModel: NavigationStackViewModel
    
    private let content: Content
    private let destination: Destination
    
    public init(destination: Destination,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.destination = destination
    }
    
    public var body: some View {
        content.onTapGesture {
            viewModel.push(destination)
        }
    }
}

public struct NavigationPopButton<Content>: View where Content: View {
    
    @EnvironmentObject var viewModel: NavigationStackViewModel
    
    private let content: Content
    private let destination: PopDestination
    
    public init(destination: PopDestination,
                @ViewBuilder content: @escaping () -> Content) {
        self.content = content()
        self.destination = destination
    }
    
    public var body: some View {
        content.onTapGesture {
            viewModel.pop(to: destination)
        }
    }
}

// MARK: - Enums

public enum PopDestination {
    case previous, root
}

// MARK: - Logic

private struct Screen: Identifiable, Equatable {
    
    let id: String
    let nextScreen: AnyView
    
    static func == (lhs: Screen, rhs: Screen) -> Bool {
        lhs.id == rhs.id
    }
    
}

private struct ScreenStack {
    
     fileprivate var screens: [Screen] = []
    
    func top() -> Screen? {
        screens.last
    }
    
    mutating func push(_ s: Screen) {
        screens.append(s)
    }
    
    mutating func popToPrevious() {
        _ = screens.popLast()
    }
    
    mutating func popToRoot() {
        screens.removeAll()
    }
    
}
