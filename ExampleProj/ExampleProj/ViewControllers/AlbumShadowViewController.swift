//
//  AlbumShadowViewController.swift
//  ExampleProj
//
//  Created by 梁光辉 on 2022/2/12.
//

import UIKit
import GHPrettyViews

class AlbumShadowViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        // Do any additional setup after loading the view.
    }
    
    private lazy var stackView = UIStackView().then { stack in
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.bottom.equalTo(-100)
        }
        
        let orientations = ["上", "下", "左", "右"]
        for index in 0...3 {
            let targetView = ShadowView(title: orientations[index])
            stackView.addArrangedSubview(targetView)
            let config = AlbumShadowViewConfig(margin: 5, offset: 6, orientation: .init(rawValue: index)!, color: UIColor.gray, colorAlpha: 0.2, shouldAddShadow: true)
            AlbumShadowView.install(onSuperView: view, forTargetView: targetView, withConfig: config)
        }
    }
}

final class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(title: String) {
        self.init()
        titleLabel.text = title
    }
    
    private lazy var titleLabel = UILabel().then { label in
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
    }
    
    private func setupViews() {
        backgroundColor = .systemGray
        layer.masksToBounds = true
        layer.cornerRadius = 8
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
