//
//  ButtonChangeIntent.swift
//  LiveActivityKit
//

import Foundation
import AppIntents
import ActivityKit

@available(iOS 18, *)
public struct ButtonChangeIntent: LiveActivityIntent {
    public static var title: LocalizedStringResource = "Change Page"
    public static var description = IntentDescription("Changes the page index of the live activity")
    
    @Parameter(title: "Forward")
    public var forward: Bool
    
    @Parameter(title: "Activity Id")
    public var activityId: String?
    
    public init() {
        self.forward = true
    }
    
    public init(activityId: String?, forward: Bool) {
        self.activityId = activityId
        self.forward = forward
    }
    
    public func perform() async throws -> some IntentResult {
        guard let activityId else { return .result() }
        guard let activity = Activity<LiveActivityAttributes>.activities.first(where: { $0.id == activityId }) else {
            return .result()
        }
        
        let currentState = activity.content.state
        let currentIndex = currentState.pageIndex ?? 0
        let maxIndex = max(0, currentState.items.count - 1)
        
        let newIndex: Int
        if forward {
            newIndex = min(currentIndex + 1, maxIndex)
        } else {
            newIndex = max(currentIndex - 1, 0)
        }
        
        var newState = currentState
        newState.pageIndex = newIndex
        let attrs = activity.attributes
        
        await activity.update(
            ActivityContent(
                state: newState,
                staleDate: nil
            ),
            alertConfiguration: nil,
            timestamp: Date()
        )
        
        return .result()
    }
}
