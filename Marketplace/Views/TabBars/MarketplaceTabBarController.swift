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
        itemFeedVC.tabBarItem = UITabBarItem(title: Constants.itemFeed, image: Images.tag, tag: 0)
        return UINavigationController(rootViewController: itemFeedVC)
    }

    private func SellItemNavigationController() -> UINavigationController {
        let sellItemVC = SellItemViewController()
        sellItemVC.tabBarItem = UITabBarItem(title: Constants.sellItem , image: Images.dollarsignCircle, tag: 1)
        return UINavigationController(rootViewController: sellItemVC)

    }
    
    private func ProfileNavigationController() -> UINavigationController {
        let profileVC = ProfileViewController()
        profileVC.tabBarItem = UITabBarItem(title: Constants.profile, image: Images.personImage, tag: 2)
        return UINavigationController(rootViewController: profileVC)

    }
}
