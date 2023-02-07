//
//  UIViewControllerExtensions.swift
//  perqara
//
//  Created by Muhammad Syafrizal on 06/02/23.
//

import Foundation
import UIKit
import SnapKit

extension UIViewController {
    func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
    
    func handleError(_ error: Error) {
        print("---- ERROR ------")
        print(error)
        print("---- ERROR ------")
    }
    
    @objc func showActivityIndicator() {
        showActivityIndicatorCenter()
    }
    
    func showActivityIndicatorCenter() {
        let overlay = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlay.tag = Constants.ACTIVITY_INDICATOR_TAG
        overlay.backgroundColor = .clear
        overlay.isUserInteractionEnabled = true
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)
        overlay.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.edges.equalTo(view)
        }
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.backgroundColor = UIColor(red:0.16, green:0.17, blue:0.21, alpha:1)
        activityIndicator.layer.cornerRadius = 6
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.tag = Constants.ACTIVITY_INDICATOR_TAG
        overlay.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { (make: ConstraintMaker) -> Void in
            make.height.width.equalTo(100)
            make.center.equalTo(overlay)
        }
        activityIndicator.startAnimating()
    }
    
    @objc func hideActivityIndicator() {
        let activityIndicator = view.viewWithTag(Constants.ACTIVITY_INDICATOR_TAG)
        (activityIndicator as? UIActivityIndicatorView)?.stopAnimating()
        self.view.isUserInteractionEnabled = true
        activityIndicator?.removeFromSuperview()
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
