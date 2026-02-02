//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by Bradley Slayter on 1/8/26.
//

import ActivityKit
import WidgetKit
import SwiftUI
import AppIntents

struct Item: Codable, Hashable {
    var emoji: String
}

struct LiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var pageIndex: Int?
        var items: [Item]
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LiveActivityLiveActivity: Widget {
    
    func currentItem(from state: LiveActivityAttributes.ContentState) -> Item {
        guard let pageIndex = state.pageIndex, pageIndex < state.items.count else {
            return state.items[0]
        }
        return state.items[pageIndex]
    }
    
    func hasPrevLegs(_ state: LiveActivityAttributes.ContentState) -> Bool {
        let pageIndex = state.pageIndex ?? 0
        return pageIndex > 0
    }
    
    func hasNextLegs(_ state: LiveActivityAttributes.ContentState) -> Bool {
        let pageIndex = state.pageIndex ?? 0
        return pageIndex < (state.items.count - 1)
    }
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            let currentItem = currentItem(from: context.state)
            // Lock screen/banner UI goes here
            HStack {
                Button(intent: ButtonChangeIntent(activityId: context.activityID, forward: false)) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .background(.clear)
                }
                
                Text("Hello \(currentItem.emoji)")
                
                Button(intent: ButtonChangeIntent(activityId: context.activityID, forward: true)) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .aspectRatio(contentMode: .fit)
                        .background(.clear)
                }
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            let currentItem = currentItem(from: context.state)
            return DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Button(intent: ButtonChangeIntent(activityId: context.activityID, forward: false)) {
                        Image(systemName: "chevron.left")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .background(.clear)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Button(intent: ButtonChangeIntent(activityId: context.activityID, forward: true)) {
                        Image(systemName: "chevron.right")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .aspectRatio(contentMode: .fit)
                            .background(.clear)
                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(currentItem.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(currentItem.emoji)")
            } minimal: {
                Text(currentItem.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LiveActivityAttributes {
    fileprivate static var preview: LiveActivityAttributes {
        LiveActivityAttributes(name: "World")
    }
}

extension LiveActivityAttributes.ContentState {
    fileprivate static var smiley: LiveActivityAttributes.ContentState {
        LiveActivityAttributes.ContentState(items: [Item(emoji: "🤩")])
     }
     
     fileprivate static var starEyes: LiveActivityAttributes.ContentState {
         LiveActivityAttributes.ContentState(items: [Item(emoji: "🤩")])
     }
}

#Preview("Notification", as: .content, using: LiveActivityAttributes.preview) {
   LiveActivityLiveActivity()
} contentStates: {
    LiveActivityAttributes.ContentState.smiley
    LiveActivityAttributes.ContentState.starEyes
}
