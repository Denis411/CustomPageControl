//
//  CustomPageControl.swift
//  CustomPageControl
//
//  Created by Dennis Loskutov on 12.08.2022.
//

import UIKit

final class IndexableLabel: UILabel {
    public var index: Int
    
    init(index: Int) {
        self.index = index
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

protocol CustomPageControlDelegate {
    func shouldChangePresentedController(for index: Int)
}

final class CustomPageControl: UIView {
    private let taps: [String]
    private var labels: [IndexableLabel] = []
    private let viewHeight: CGFloat = 50.0
    
    private let scroll = UIScrollView()
    private let stack = UIStackView()
    private let separator = UIView()
    private let heighLighter = UIView()
    
    private var leftConstraintForHeighLighter  = NSLayoutConstraint()
    private var heightConstraintForHeighLighter = NSLayoutConstraint()
    
    private(set) var indexOfCurrentVC: Int = 0
    
    var delegate: CustomPageControlDelegate?
    
    init(taps: [String]) {
        self.taps = taps
        super.init(frame: .zero)
        setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeIndexOfCurrentVC(for index: Int) {
        guard indexOfCurrentVC != index else { return }
        self.indexOfCurrentVC = index
        animateTransitionBetweenTaps()
    }
    
    private func setUpUI() {
        self.clipsToBounds = true
        createLabels()
        setUpScrollView()
        setUpStackView()
        setSeparator()
        setHeighLighter()
    }
    
    private func createLabels() {
        for index in 0..<taps.count {
            let label = IndexableLabel(index: index)
            label.text = taps[index]
            label.font = .systemFont(ofSize: 20)
            labels.append(label)
            stack.addArrangedSubview(label)
        }
        
        let gr = UITapGestureRecognizer(target: self, action: #selector(addForLabel(_:)))
        gr.cancelsTouchesInView = false
        scroll.addGestureRecognizer(gr)
    }
    
    private func setUpScrollView() {
        self.addSubview(scroll)
        scroll.bounces = false
        scroll.showsHorizontalScrollIndicator = false
        scroll.showsVerticalScrollIndicator = false
        
        scroll.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(viewHeight)
        }
    }
    
    private func setUpStackView() {
        stack.axis = .horizontal
        stack.spacing = 20
        stack.alignment = .leading
        
        scroll.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func setSeparator() {
        separator.backgroundColor = .gray
        self.addSubview(separator)
        separator.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(stack).offset(5)
            make.left.right.equalToSuperview()
        }
    }
    
    private func setHeighLighter() {
        heighLighter.backgroundColor = .black
        heighLighter.layer.cornerRadius = 2
        
        scroll.addSubview(heighLighter)
        heighLighter.translatesAutoresizingMaskIntoConstraints = false
        
        heighLighter.heightAnchor.constraint(equalToConstant: 4).isActive = true
        heighLighter.bottomAnchor.constraint(equalTo: stack.bottomAnchor, constant: 7).isActive = true
        
        leftConstraintForHeighLighter = heighLighter.leftAnchor.constraint(equalTo: labels[indexOfCurrentVC].leftAnchor)
        leftConstraintForHeighLighter.isActive = true
        
        heightConstraintForHeighLighter = heighLighter.widthAnchor.constraint(equalToConstant: 50)
        heightConstraintForHeighLighter.isActive = true
    }
    
    @objc private func addForLabel(_ sender: UITapGestureRecognizer) {
        guard let index = defineIndexByRecognizer(sender: sender) else {
            return
        }
        
        indexOfCurrentVC = index
        delegate?.shouldChangePresentedController(for: index)
        animateTransitionBetweenTaps()
    }
    
    private func animateTransitionBetweenTaps() {
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.leftConstraintForHeighLighter.isActive = false
            self.leftConstraintForHeighLighter = heighLighter.leftAnchor.constraint(equalTo: labels[indexOfCurrentVC].leftAnchor)
            self.leftConstraintForHeighLighter.isActive = true
            self.heightConstraintForHeighLighter.constant = labels[indexOfCurrentVC].frame.width
            self.layoutIfNeeded()
        }
    }
    
    private func defineIndexByRecognizer(sender: UITapGestureRecognizer) -> Int? {
        let senderLocation = sender.location(in: scroll)
        var returnIndex: Int? = nil
        
        for labelIndex in 0..<labels.count {
            let labelFrame = stack.arrangedSubviews[labelIndex].frame
            let rangeOfLabel = labelFrame.origin.x..<labelFrame.origin.x + labelFrame.size.width
            
            if rangeOfLabel.contains(senderLocation.x) {
                returnIndex = labelIndex
                setScrollOffset(forViewInFrame: labelFrame)
                break
            } else {
                continue
            }
        }
        return returnIndex
    }
    
    private func setScrollOffset(forViewInFrame: CGRect) {
        let endPointOfView = forViewInFrame.origin.x
        
        if (endPointOfView + forViewInFrame.origin.x) < scroll.frame.maxX {
            scroll.setContentOffset(CGPoint(x: forViewInFrame.origin.x, y: 0), animated: true)
        } else {
            return
        }
    }
}
