//
//  Appdelegate.swift
//  movie-app-live
//
//  Created by Zsolt Pete on 2025. 04. 15..
//

import UIKit
import InjectPropertyWrapper
import Swinject

class AppDelegate: NSObject, UIApplicationDelegate {
    let assembler: MainAssembler
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("AppDelegate - App launched")
        return true
    }
    
    override init() {
        assembler = MainAssembler.create(withAssemblies: [
            ServiceAssembly()
        ])
        InjectSettings.resolver = assembler.container
    }
}
