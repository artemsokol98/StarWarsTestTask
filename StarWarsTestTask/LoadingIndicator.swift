//
//  LoadingIndicator.swift
//  StarWarsTestTask
//
//  Created by Артем Соколовский on 15.12.2022.
//

import UIKit

class LoadingIndicator: UIView {

    static let shared = LoadingIndicator()
    
    func showLoading(in view: UIView) -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        return activityIndicator
    }

}
