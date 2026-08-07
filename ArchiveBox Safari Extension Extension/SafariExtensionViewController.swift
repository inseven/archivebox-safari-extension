//
//  SafariExtensionViewController.swift
//  ArchiveBox Safari Extension Extension
//
//  Created by Jason Barrie Morley on 30/05/2024.
//

import SafariServices

class SafariExtensionViewController: SFSafariExtensionViewController {
    
    static let shared: SafariExtensionViewController = {
        let shared = SafariExtensionViewController()
        shared.preferredContentSize = NSSize(width:320, height:240)
        return shared
    }()

}
