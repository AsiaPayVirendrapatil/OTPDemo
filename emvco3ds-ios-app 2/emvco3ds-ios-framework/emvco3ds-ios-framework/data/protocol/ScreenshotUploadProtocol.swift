//  ScreenshotUploadProtocol.swift
//  emvco3ds-ios-app
//
//  Copyright © 2018 UL Transaction Security. All rights reserved.

import UIKit

protocol ScreenshotUploadProtocol {
    func onSuccessfull(message:String)
    func onError(message:String)
}
