//
//  UIViewControllerExtensions.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit

extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
}

extension String {
    func escaped(_ chars: String = ";/?:@&=+$, ") -> String? {
        var set =  NSCharacterSet.urlQueryAllowed
        set.remove(charactersIn: chars)
        guard let escapedString = self.addingPercentEncoding(withAllowedCharacters: set) else {
            return nil
        }
        return escapedString
    }
    
    func quoteEscape() -> String {
        var escaped = self
        escaped = escaped.replacingOccurrences(of: "\\", with: "\\\\")
        escaped = escaped.replacingOccurrences(of: "\'", with: "\\\'")
        escaped = escaped.replacingOccurrences(of: "\"", with: "\\\"")
        escaped = escaped.replacingOccurrences(of: "\n", with: "\\n")
        escaped = escaped.replacingOccurrences(of: "\r", with: "\\r")
        escaped = escaped.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        escaped = escaped.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
        return escaped
    }
}
