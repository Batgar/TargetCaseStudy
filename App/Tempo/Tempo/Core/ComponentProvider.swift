//
//  ComponentProvider.swift
//  HarmonyKit
//
//  Created by Adam May on 11/13/15.
//  Copyright © 2015 Target. All rights reserved.
//

import Foundation

open class ComponentProvider {
    let components: [ComponentType]
    let dispatcher: Dispatcher

    public init(components: [ComponentType], dispatcher: Dispatcher) {
        self.components = components
        self.dispatcher = dispatcher
    }

    open func registerComponents(_ container: ReusableViewContainer) {
        for component in components {
            component.registerWrappers(container)
        }
    }

    open func componentFor(_ item: TempoViewStateItem) -> ComponentType {
        for var component in components {
            if component.canDisplayItem(item) {
                component.dispatcher = dispatcher
                return component
            }
        }

        fatalError("Missing component for \(item)")
    }
}
