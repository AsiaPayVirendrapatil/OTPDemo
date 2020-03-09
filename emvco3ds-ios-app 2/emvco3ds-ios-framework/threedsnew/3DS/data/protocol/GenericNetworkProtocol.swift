//  GenericNetworkProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2017 UL Transaction Security. All rights reserved.

import UIKit

public protocol GenericNetworkProtocol {
    func onFailure(errorMessage : String)
    func onResponse(responseObject : NSObject)
    func onErrorResponse(errorMessage : String)
    func nothingFonaHappended()
}
