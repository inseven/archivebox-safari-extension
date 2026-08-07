//
//  SafariExtensionHandler.swift
//  ArchiveBox Safari Extension Extension
//
//  Created by Jason Barrie Morley on 30/05/2024.
//

import SafariServices
import os.log

class SafariExtensionHandler: SFSafariExtensionHandler {

    override func beginRequest(with context: NSExtensionContext) {
        let request = context.inputItems.first as? NSExtensionItem

        let profile: UUID?
        if #available(iOS 17.0, macOS 14.0, *) {
            profile = request?.userInfo?[SFExtensionProfileKey] as? UUID
        } else {
            profile = request?.userInfo?["profile"] as? UUID
        }

        os_log(.default, "The extension received a request for profile: %@", profile?.uuidString ?? "none")
    }

    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        page.getPropertiesWithCompletionHandler { properties in
            os_log(.default, "The extension received a message (%@) from a script injected into (%@) with userInfo (%@)", messageName, String(describing: properties?.url), userInfo ?? [:])
        }
    }

    override func toolbarItemClicked(in window: SFSafariWindow) {
        os_log(.default, "The extension's toolbar item was clicked")

        Task {
            guard let activeTab = await window.activeTab(),
                  let activePage = await activeTab.activePage(),
                  let properties = await activePage.properties(),
                  let url = properties.url,
                  var components = URLComponents(string: "https://archivebox.home.jbmorley.co.uk/add")
            else {
                return
            }

            components.queryItems = [
                URLQueryItem(name: "url", value: url.absoluteString)
            ]

            guard let addURL = components.url else {
                return
            }

            activeTab.navigate(to: addURL)
        }

//        window.getActiveTab { tab in
//            guard let tab else {
//                return
//            }
//            tab.getActivePage { page in
//                guard let page else {
//                    return
//                }
//                page.getPropertiesWithCompletionHandler { properties in
//                    guard let properties,
//                          let url = properties.url else {
//                        return
//                    }
//                    os_log(.default, "ArchiveBox: %@", url.absoluteString)
//                }
//            }
//        }
    }

    override func validateToolbarItem(in window: SFSafariWindow, validationHandler: @escaping ((Bool, String) -> Void)) {
        validationHandler(true, "")
    }

    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
