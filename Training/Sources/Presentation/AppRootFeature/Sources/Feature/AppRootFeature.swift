//
//  AppRootFeature.swift
//  AppRootFeature
//
//  Created by hideto.higashi on 2025/03/04.
//

import ComposableArchitecture

@Reducer
public struct AppRootFeature {
    public init() {}

    public struct State {
        public init() {}
    }

    public enum Action {}

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}
