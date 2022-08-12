//
//  ViewController.swift
//  CustomPageControl
//
//  Created by Dennis Loskutov on 10.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    let customPageControl = CustomPageControl(taps: ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh"])
    var pages: [UIViewController] = []

    let pageVC = UIPageViewController()
    let initialVCIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(customPageControl)
        customPageControl.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(40)
            make.height.equalTo(100)
        }
        view.backgroundColor = .white
        
        setPageVC()
        setVCsForPageVC()
    }
    
    private func setPageVC() {
        guard let pageView = pageVC.view else { return }
        view.addSubview(pageView)
        pageView.snp.makeConstraints { make in
            make.top.equalTo(customPageControl.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
        pageView.backgroundColor = .green
    }
    
    private func setVCsForPageVC() {
        let vcOne = UIViewController()
        vcOne.view.backgroundColor = .orange
        let vcTwo = UIViewController()
        vcTwo.view.backgroundColor = .blue
        let vcThree = UIViewController()
        vcThree.view.backgroundColor = .yellow
        
        pages.append(vcOne)
        pages.append(vcTwo)
        pages.append(vcThree)
        
        pageVC.setViewControllers([pages[initialVCIndex]], direction: .forward, animated: true, completion: nil)
    }
}
