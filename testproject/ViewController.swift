//
//  ViewController.swift
//  testproject
//
//  Created by Tetsuro Watanabe on 2021/03/10.
//

import UIKit

struct Test: Codable {
    let userName: String
    let comment: String
    
    enum CodingKeys: String, CodingKey {
        case userName = "user_name"
        case comment = "comment"
        
    }
}

class ViewController: UIViewController {
    
    private let celId = "celId"
    private var tests = [Test]()
    
    let tableView: UITableView = {
        let tv = UITableView()
        
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame.size = view.frame.size
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TestTableViewCell.self, forCellReuseIdentifier: celId)
        
        getTestApi()
    }
    private func getTestApi(){
        guard let url = URL(string: "https://greensnap-co-jp.s3-ap-northeast-1.amazonaws.com/exam/post_data.json") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("情報の取得に失敗しました。:", err)
                return
            }
            
            if let data = data {
                do {
                    //let json = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    let test = try JSONDecoder().decode([Test].self, from: data)
                    self.tests = test
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                    print("json:",test)
                } catch(let err) {
                    print("情報の取得に失敗しました。:", err)
                }
                
            }
        }
        task.resume()
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath) as! TestTableViewCell
        //cell.backgroundColor = .red
        
        cell.Test = tests[indexPath.row]
        return cell
    }
    
    
}

class TestTableViewCell: UITableViewCell {
    
    var Test: Test? {
        didSet {
            bodyTextLabel.text = Test?.userName.description
            bodyTextLabel.text = Test?.comment.debugDescription
        }
    }
    
    let bodyTextLabel: UILabel = {
        let label = UILabel()
        label.text = "something in here"
        label.font = .systemFont(ofSize: 10)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        addSubview(bodyTextLabel)
        [
            
            bodyTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            ].forEach{ $0.isActive = true }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
