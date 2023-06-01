//
//  Extensions.swift
//  SchoolCoreDataTutorial
//
//  Created by Štěpán Friedl on 29.05.2023.
//

import SwiftUI

extension View {
    func setToolbarBackground() -> some View {
        if #available(iOS 16.0, *) {
            return self
                .toolbarBackground(Color(.secondarySystemBackground), for: .navigationBar)
                .toolbarBackground(.visible, for: .navigationBar)
        } else {
            return self
        }
    }
}
