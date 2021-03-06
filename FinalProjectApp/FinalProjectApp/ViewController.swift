import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var climateLabel: UILabel!
    @IBOutlet weak var gravityLabel: UILabel!
    var inputNum: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
    }
    
    struct Response: Codable {
        let name: String
        let climate: String
        let gravity: String
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //textField code
        textField.resignFirstResponder()  //if desired
        grab()
        return true
    }
    
    
    func grab() {
        let inputNum = textField.text!
        let apiURL = URL(string: "https://swapi.dev/api/planets/\(inputNum)/")!
        let task = URLSession.shared.dataTask(with: apiURL) { (data, response, error) in
            if let data = data {
                do { let dictionary = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
                    print(dictionary)
                    let res = try JSONDecoder().decode(Response.self, from: data)
                    DispatchQueue.main.async() {
                        self.labelView.text = String(res.name)
                        self.climateLabel.text = "Climate: " + String(res.climate)
                        self.gravityLabel.text = "Gravity: \(res.gravity)"
                    }
                }
                catch {
                    print("This errored out for some reason :(")
                    DispatchQueue.main.async {
                    self.labelView.text = "No :)"
                        self.climateLabel.text = "u thought"
                        self.gravityLabel.text = "sike"
                    }
                }
            }
        }
        task.resume()
    }
}

