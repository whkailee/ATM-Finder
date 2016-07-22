//
//  ATM.swift
//  ATMFinder
//
//  Created by Steven Li on 21/07/16.
//  Copyright © 2016 Xinc. All rights reserved.
//

import UIKit

class ATM: Location {
    var atmID: NSString?
    var atmCount: Double = 0
    var hasAudio: Bool = false
    var availabilityDescription: NSString?
    
    var placement: NSString?
    var isCustomerFacing: Bool = false
    var hasEnvelopeDispenser: Bool = false
    var hasBusinessDeposit: Bool = false
    var hasPersonalDeposit: Bool = false
    var hasNoteAcceptor: Bool = false
    var hasChequeAcceptor: Bool = false
    var hasCoinAcceptor: Bool = false
    var hasBusinessDepositOnly: Bool = false
    var hasNoteAndChequeAcceptor: Bool = false
}
