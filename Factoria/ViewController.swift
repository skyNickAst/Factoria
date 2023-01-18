//
//  ViewController.swift
//  Factoria
//
//  Created by Nikolai Astakhov on 18.01.2023.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var factsArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        getData()
    }
    
    func getData() {
        factsArray = []
        let url = URL(string: "https://api.api-ninjas.com/v1/facts?limit=15")!
        var request = URLRequest(url: url)
        // This is a free API KEY, so don't try to steal xD
        request.setValue("allebLzN4xvbojQtrN6AOg==7xJ5OIaUtXXykmEH", forHTTPHeaderField: "X-Api-Key")
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            guard let data = data else { return }
            let dataJSON = JSON(data)
            DispatchQueue.main.async {
                // The number of facts we get contains in url -> "limit=15"
                for i in 0...14 {
                    self.factsArray.append(dataJSON[i]["fact"].stringValue)
                    
                }
                self.tableView.reloadData()
            }
        }
        task.resume()
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return factsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = factsArray[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 23.0)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = message
        return cell
    }
    
    @IBAction func getMorePressed(_ sender: UIButton) {
        getData()
    }
}
