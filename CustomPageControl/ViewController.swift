//
//  ViewController.swift
//  CustomPageControl
//
//  Created by Dennis Loskutov on 10.08.2022.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    private let customPageControl = CustomPageControl(taps: ["First", "Second", "Third", "Fourth", "Fifth", "Sixth", "Seventh"])
    private var pages: [UIViewController] = []

    private let pageVC = UIPageViewController()
    private var currentlyPresentedVC = 0
    
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
        let vcFour = UIViewController()
        vcFour.view.backgroundColor = .orange
        let vcFive = UIViewController()
        vcFive.view.backgroundColor = .blue
        let vcSix = UIViewController()
        vcSix.view.backgroundColor = .yellow
        let vcSeven = UIViewController()
        vcSeven.view.backgroundColor = .black
        
        pages.append(vcOne)
        pages.append(vcTwo)
        pages.append(vcThree)
        pages.append(vcFour)
        pages.append(vcFive)
        pages.append(vcSix)
        pages.append(vcSeven)
        
        pageVC.setViewControllers([pages[currentlyPresentedVC]], direction: .forward, animated: true, completion: nil)
        
        pageVC.dataSource = self
        pageVC.delegate = self
    }
}

extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        
        if currentIndex == 0 {
            currentlyPresentedVC = pages.count - 1
            return pages.last
        } else {
            currentlyPresentedVC = currentIndex - 1
            return pages[currentIndex - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else { return nil}
        
        if currentIndex < pages.count - 1 {
            currentlyPresentedVC = currentIndex + 1
            return pages[currentIndex + 1]
        } else {
            currentlyPresentedVC = 0
            return pages.first
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            customPageControl.changeIndexOfCurrentVC(for: currentlyPresentedVC)
        }
    }
}

