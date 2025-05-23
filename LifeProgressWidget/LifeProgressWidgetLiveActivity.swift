//
//  LifeProgressWidgetLiveActivity.swift
//  LifeProgressWidget
//
//  Created by yuki on R 7/04/06.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct LifeProgressWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct LifeProgressWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LifeProgressWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension LifeProgressWidgetAttributes {
    fileprivate static var preview: LifeProgressWidgetAttributes {
        LifeProgressWidgetAttributes(name: "World")
    }
}

extension LifeProgressWidgetAttributes.ContentState {
    fileprivate static var smiley: LifeProgressWidgetAttributes.ContentState {
        LifeProgressWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: LifeProgressWidgetAttributes.ContentState {
         LifeProgressWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: LifeProgressWidgetAttributes.preview) {
   LifeProgressWidgetLiveActivity()
} contentStates: {
    LifeProgressWidgetAttributes.ContentState.smiley
    LifeProgressWidgetAttributes.ContentState.starEyes
}
