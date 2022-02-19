//
//  ViewController.swift
//  ExampleProj
//
//  Created by 梁光辉 on 2022/2/12.
//

import UIKit

import GHFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    private let tableView = UITableView().then { table in
        table.showsVerticalScrollIndicator = false
    }
    
    private let controllersDic: [String: AnyClass] = [:]
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return controllersDic.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
