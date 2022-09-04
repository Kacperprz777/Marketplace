//
//  MarketplaceTabBarController.swift
//  Marketplace
//
//  Created by Paweł Przybyła on 03/09/2022.
//

import UIKit

class MarketplaceTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = [ItemFeedNavigationController(), SellItemNavigationController(), ProfileNavigationController()]
    }
    
    private func ItemFeedNavigationController() -> UINavigationController {
        let itemFeedVC = ItemFeedViewController()
        itemFeedVC.tabBarItem = UITabBarItem(title: "Item Feed", image: UIImage(systemName: "tag"), tag: 0)
        return UINavigationController(rootViewController: itemFeedVC)
    }

    private func SellItemNavigationController() -> UINavigationController {
        let sellItemVC = SellItemViewController()
        sellItemVC.tabBarItem = UITabBarItem(title: "Sell Item", image: UIImage(systemName: "dollarsign.circle"), tag: 1)
        return UINavigationController(rootViewController: sellItemVC)

    }
    
    private func ProfileNavigationController() -> UINavigationController {
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        return UINavigationController(rootViewController: profileVC)

    }
}
