//
//  AppDelegate.swift
//  testapp
//
//  Created by Bradley Slayter on 1/8/26.
//

import UIKit
import ActivityKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private var activityObservationTask: Task<Void, Never>?
    private var tokenObservationTasks: [String: Task<Void, Never>] = [:]
    private var cachedTokens: [String: String] = [:]

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        activityObservationTask = Task {
            for await activity in Activity<LiveActivityAttributes>.activityUpdates {
                guard activity.activityState == .active else { continue }
                tokenObservationTasks[activity.id] = Task {
                    for await pushToken in activity.pushTokenUpdates {
                        let tokenString = pushToken.reduce("") {
                            $0 + String(format: "%02x", $1)
                        }
                        print("PUSH ATTRIBUTES: \(activity.attributes)")
                        print("PUSH TOKEN: \(tokenString)")
                        
                        cachedTokens[activity.id] = tokenString
                    }
                }
            }
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

