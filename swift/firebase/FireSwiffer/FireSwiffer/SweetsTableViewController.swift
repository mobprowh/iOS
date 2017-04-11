//
//  SweetsTableViewController.swift
//  FireSwiffer
//
//  Created by andrey on 2/28/17.
//  Copyright © 2017 andrey. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class SweetsTableViewController: UITableViewController {
    
    var dbRef:FIRDatabaseReference!
    var sweets = [Sweet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dbRef = FIRDatabase.database().reference().child("sweet-item")
        //startObservingDB()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //FIRAuth.auth()?.addStateDidChangeListener({ (auth:FIRAuth, user:FIRUser) in
            
          //      print("Welcome \(user.email)")
            
        //} as! FIRAuthStateDidChangeListenerBlock )
        FIRAuth.auth()?.addStateDidChangeListener({ (auth:FIRAuth, user:FIRUser?) in
            if let user = user{
                print("Welcome \(user.email)")
                self.startObservingDB()
            }else{
                print("You need to sign up or login first")
            }
        })
    }
    
    func startObservingDB() {
        dbRef.observe(.value, with: { (snapshot:FIRDataSnapshot) in
            var newSweets = [Sweet]()
            
            for sweet in snapshot.children{
                let sweetObject = Sweet(snapshot: sweet as! FIRDataSnapshot)
                newSweets.append(sweetObject)
            }
            
            self.sweets = newSweets
            self.tableView.reloadData()
            
        }) { (error:Error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func loginAndSignup(_ sender: Any) {
        
        let userAlert = UIAlertController(title: "Login/Sign up", message: "Enter email and password", preferredStyle: .alert)
        userAlert.addTextField { (textfield:UITextField) in
            textfield.placeholder = "email"
        }
        userAlert.addTextField { (textfield:UITextField) in
            textfield.isSecureTextEntry = true
            textfield.placeholder = "password"
        }
        
        userAlert.addAction(UIAlertAction(title: "Sign in", style: .default, handler: { (action:UIAlertAction) in
            let emailTextField = userAlert.textFields!.first!
            let passwordtextField = userAlert.textFields!.last!
            
            FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordtextField.text!, completion: { (user:FIRUser?, error:Error?) in
                if error != nil{
                    print(error?.localizedDescription as Any)
                }
            })
        }))
        
        userAlert.addAction(UIAlertAction(title: "Sign Up", style: .default, handler: { (action:UIAlertAction) in
            let emailtextfield = userAlert.textFields?.first!
            let passwordtextfield = userAlert.textFields?.last!
            
            FIRAuth.auth()?.createUser(withEmail: (emailtextfield?.text)!, password: (passwordtextfield?.text)!, completion: { (user:FIRUser?, error:Error?) in
                if error != nil{
                    print(error?.localizedDescription as Any)
                }
            })
        }))
        
        self.present(userAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func addSweet(_ sender: Any) {
        let sweetAlert = UIAlertController(title: "New Sweet", message: "Enter your Sweet", preferredStyle: .alert)
        sweetAlert.addTextField { (textField:UITextField) in
            textField.placeholder = "Your sweet"
        }
        sweetAlert.addAction(UIAlertAction(title: "send", style: .default, handler: { (action:UIAlertAction) in
            if let sweetContent = sweetAlert.textFields?.first?.text{
                
                let sweet = Sweet(content: sweetContent, addedByUser: "Test")
                
                let sweetRef = self.dbRef.child(sweetContent.lowercased())
                
                sweetRef.setValue(sweet.toAnyObject())
                
            }
        }))
        
        self.present(sweetAlert, animated: true, completion: nil)
        
    }


    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sweets.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        // Configure the cell...
        
        let sweet = sweets[indexPath.row]
        
        cell.textLabel?.text = sweet.content
        cell.detailTextLabel?.text = sweet.addedByUser

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let sweet = sweets[indexPath.row]
            
            sweet.itemRef?.removeValue()
        }
    }
    



}
