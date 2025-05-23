//
//  AppRootView.swift
//  AppRootFeature
//
//  Created by hideto.higashi on 2025/03/04.
//

import SwiftUI
import ComposableArchitecture

public struct AppRootView: View {
    public init(store: StoreOf<AppRootFeature>) {
        self.store = store
    }

    let store: StoreOf<AppRootFeature>

    public var body: some View {
        Text("AppRootView")
    }
}

#Preview {
    AppRootView(
        store: Store(
            initialState: AppRootFeature.State(),
            reducer: { AppRootFeature() }
        )
    )
}
