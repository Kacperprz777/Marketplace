//
//  UIImageView+Extension.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 11/09/2022.
//

import UIKit

extension UIImageView {
  func loadImage(at url: URL?) {
      guard let url = url else { return }

    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
