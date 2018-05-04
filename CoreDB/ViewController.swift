//
//  ViewController.swift
//  CoreDB
//
//  Created by NguyenDucToan on 5/3/18.
//  Copyright © 2018 NguyenDucToan. All rights reserved.
//

import UIKit
import CoreData

var number:Int!
var datas:[NSManagedObject]! = []

class ViewController: UIViewController , UITextFieldDelegate ,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return number
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        
        let person = datas[indexPath.row]
        
        cell?.textLabel?.text = person.value(forKeyPath: "phone") as? String
        return cell!
        
    }
    
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtDate: UIDatePicker!
    @IBAction func Date(_ sender: Any) {
    }
    @IBOutlet weak var myTable: UITableView!
    
    @IBAction func Coppy(_ sender: Any) {
        UIPasteboard.general.string = txtName.text!
        print("done")
    }
    @IBAction func Past(_ sender: Any) {
        if let myString = UIPasteboard.general.string {
            txtEmail.text = myString.uppercased()
            print("past done")
        }
    }
    @IBAction func Save(_ sender: Any){
       saveDB()
        txtPhone.text = ""
        txtName.text = ""
        txtEmail.text = ""
    }
    @IBAction func Read(_ sender: Any){
       readDB()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        number = 0
        // Do any additional setup after loading the view, typically from a nib.
        self.txtName.delegate = self
        myTable.dataSource = self
    }
    
    //======
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)    {
        self.view.endEditing(true)
    }
    
    //======
    func saveDB() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        newUser.setValue(txtName.text!, forKey: "name")
        newUser.setValue(txtEmail.text!, forKey: "email")
        newUser.setValue(1, forKey: "identify")
        newUser.setValue(txtPhone.text!, forKey: "phone")
        do {
            try context.save()
            print("Save done")
        } catch {
            print("Failed saving")
        }
    }
    //========
    func readDB(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
      //      datas = try managedContext.fetch(fetchRequest)
            number = result.count
            myTable.reloadData()
         //   datas = result.
            for data in result as! [NSManagedObject] {
                print(data.value(forKey: "name") as! String)
            }
            
        } catch {
            
            print("Failed")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "User")
        
        //3
        do {
            datas = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

