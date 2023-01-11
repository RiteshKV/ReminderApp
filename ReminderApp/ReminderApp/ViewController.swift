//
//  ViewController.swift
//  ReminderApp
//
//  Created by Ritesh Vishwakarma on 11/01/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var setReminderButton: UIButton!{
        didSet{
            self.setReminderButton.layer.cornerRadius = 5
            self.setReminderButton.layer.masksToBounds = true
        }
    }
    @IBOutlet weak var tblReminderList: UITableView!
    
    @IBOutlet weak var viewShadow: UIView!
    
    @IBOutlet weak var viewDetail: UIView!
    
    @IBOutlet weak var txtTitle: UITextField!
    
    @IBOutlet weak var txtDescription: UITextField!
    
    @IBOutlet weak var btnAdd: UIButton!{
        didSet{
            self.btnAdd.layer.cornerRadius = 2
            self.btnAdd.layer.masksToBounds = true
        }
    }
    
    var reminderTitle = [String]()
    var reminderBody = [String]()
    var reminderTime = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.overrideUserInterfaceStyle = .light
        datePicker.timeZone = TimeZone.current
        tblReminderList.backgroundColor = .white
        tblReminderList.dataSource  = self
        
        self.viewShadow.isHidden = true
        
        retrieveData()
    }
    
    func addReminder(title: String, body: String, time: String){
        reminderTitle.append(title)
        UserDefaults.standard.set(reminderTitle, forKey: "reminderTitle")
        reminderBody.append(body)
        UserDefaults.standard.set(reminderBody, forKey: "reminderBody")
        reminderTime.append(time)
        UserDefaults.standard.set(reminderTime, forKey: "reminderTime")
    }
    
    func retrieveData() {
        if let retrievedTitle = UserDefaults.standard.array(forKey: "reminderTitle") as? [String] {
            reminderTitle = retrievedTitle
        }
        if let retrievedBody = UserDefaults.standard.array(forKey: "reminderBody") as? [String] {
            reminderBody = retrievedBody
        }
        if let retrievedTime = UserDefaults.standard.array(forKey: "reminderTime") as? [String] {
            reminderTime = retrievedTime
        }
        tblReminderList.reloadData()
    }

    @IBAction func setReminder(_ sender: Any) {
        let currentTime = Date()
        let selectedTime = datePicker.date

        switch selectedTime.compare(currentTime) {
            case .orderedAscending:
                print("Selected time is earlier than current time.")
            showToast(message: "Please select a later time")
            case .orderedSame:
                print("Selected time is the same as current time.")
            self.viewShadow.isHidden = false
            self.txtTitle.text = ""
            self.txtDescription.text = ""
            case .orderedDescending:
                print("Selected time is later than current time.")
            self.viewShadow.isHidden = false
            self.txtTitle.text = ""
            self.txtDescription.text = ""
        }
    }
    
    @IBAction func actionAddEvent(_ sender: Any) {
        
        let content = UNMutableNotificationContent()
        content.title = self.txtTitle.text ?? ""
        content.body = self.txtDescription.text ?? ""
        self.viewShadow.isHidden = true
        view.endEditing(true)

        // Set the trigger to the date and time selected by the user
        let date = datePicker.date
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: date.timeIntervalSinceNow, repeats: false)

        let request = UNNotificationRequest(identifier: "reminder", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.showToast(message: "Reminder Added")
            }
        })
        
        addReminder(title: content.title, body: content.body, time: "\(date)")
        retrieveData()
    }
    

}

extension ViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reminderTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderTableViewCell", for: indexPath) as! ReminderTableViewCell
        
        cell.lblTtile.text = reminderTitle[indexPath.row]
        cell.lblBody.text = reminderBody[indexPath.row]
        cell.lblTime.text = convertDateFormat(inputDate: reminderTime[indexPath.row])
        
        return cell
    }
    
    
}

extension UIViewController {
    func convertDateFormat(inputDate: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: inputDate)
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy HH:mm"
        dateFormatterPrint.timeZone = TimeZone.current
        print(dateFormatterPrint.string(from: date!))
        return dateFormatterPrint.string(from: date!)
    }
    
        
    func showToast(message: String) {
        DispatchQueue.main.async {
            let toastContainer = UIView(frame: CGRect())
            toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastContainer.alpha = 0.0
            toastContainer.layer.cornerRadius = 20;
            toastContainer.clipsToBounds  =  true

            let toastLabel = UILabel(frame: CGRect())
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font.withSize(12.0)
            toastLabel.text = message
            toastLabel.clipsToBounds  =  true
            toastLabel.numberOfLines = 0

            toastContainer.addSubview(toastLabel)
            self.view.addSubview(toastContainer)

            toastLabel.translatesAutoresizingMaskIntoConstraints = false
            toastContainer.translatesAutoresizingMaskIntoConstraints = false

            let centerX = NSLayoutConstraint(item: toastLabel, attribute: .centerX, relatedBy: .equal, toItem: toastContainer, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let lableBottom = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
            let lableTop = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
            toastContainer.addConstraints([centerX, lableBottom, lableTop])

            let containerCenterX = NSLayoutConstraint(item: toastContainer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let containerTrailing = NSLayoutConstraint(item: toastContainer, attribute: .width, relatedBy: .equal, toItem: toastLabel, attribute: .width, multiplier: 1.1, constant: 0)
            let containerBottom = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
            self.view.addConstraints([containerCenterX,containerTrailing, containerBottom])

            UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
                toastContainer.alpha = 1.0
            }, completion: { _ in
                UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                    toastContainer.alpha = 0.0
                }, completion: {_ in
                    toastContainer.removeFromSuperview()
                })
            })
        }
    }
}
