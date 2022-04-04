//
//  BaseViewController.swift
//  AfroRestaurant
//
//  Created by Ebubechukwu Dimobi on 03.04.2022.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private lazy var indicatorBlurView: UIVisualEffectView = {
        let effect = UIBlurEffect(style: .dark)
        let view = UIVisualEffectView(effect: effect)
        view.alpha = 0.5
        view.isHidden = true
        return view
    }()
    
    //MARK: - lifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        navigationController?.navigationBar.barStyle = .black
    }
    
    override var prefersStatusBarHidden: Bool {
        false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
    
    func setUpUI() {
        view.backgroundColor = .background
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.tintColor = .textPrimary
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont.font(.extraBold, size: 32.0),
            NSAttributedString.Key.foregroundColor: UIColor.textPrimary
        ]
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: UIFont.font(.regular, size: 14.0),
            NSAttributedString.Key.foregroundColor: UIColor.textPrimary
        ]
        
        addSubViews()
        makeConstraints()
    }
    
    
    private func addSubViews() {
        view.addSubview(indicatorBlurView)
        indicatorBlurView.contentView.addSubview(indicator)
    }
    
    private func makeConstraints() {
        
        indicatorBlurView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    // MARK: Functions
    func showActivityIndicator() {
        indicatorBlurView.isHidden = false
        view.bringSubviewToFront(indicatorBlurView)
        indicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        indicatorBlurView.isHidden = true
        indicator.stopAnimating()
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardStartSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        handleKeyboardHeight(rect: keyboardStartSize)
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        let swipeGesture: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(dismissKeyboardOnSwipe))
        swipeGesture.direction = .down
        view.addGestureRecognizer(swipeGesture)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        handleKeyboardHeight(rect: .zero)
    }
    
    @objc private func dismissKeyboard() {
        handleTapGesture()
    }
    
    private func handleTapGesture() {
        view.endEditing(true)
    }
    
    @objc private func dismissKeyboardOnSwipe(gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .down {
            dismissKeyboard()
        }
    }
    
    func handleKeyboardHeight(rect: CGRect) {}
}

extension BaseViewController {
    
    func addKeyBoardObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification, object: nil
        )
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
}

extension BaseViewController {
    
    static var dividerView: UIView {
        let view = UIView()
        view.backgroundColor = .divider
        view.snp.makeConstraints { make in
            make.height.equalTo(0.5)
        }
        return view
    }
}
