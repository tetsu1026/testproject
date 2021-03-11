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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: celId)
        
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: celId, for: indexPath)
        cell.backgroundColor = .red
        
        return cell
    }
    
    
}
