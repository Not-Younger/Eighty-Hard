//
//  Navigation.swift
//  Eighty-Hard
//
//  Created by Jonathan Young on 10/30/25.
//

import Foundation

enum Navigation: Hashable {
    case previousResults
    case overview(challenge: Challenge)
    case tasks(day: Day?, dayNumber: Int)
    case alreadyStarted
    case alreadyStartedDataInput(challenge: Challenge)
    case moreInfo
    case settingsPage(challenge: Challenge)
    case privacyPolicy
    case termsAndConditions
}
