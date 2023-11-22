//
//  StuStayApp.swift
//  StuStay
//
//  Created by yassine on 22/11/2023.
//

import SwiftUI

@main
struct StuStayApp: App {
    var body: some Scene {
        WindowGroup {
            LogementListView(viewModel: LogementViewModel())
        }
    }
}
