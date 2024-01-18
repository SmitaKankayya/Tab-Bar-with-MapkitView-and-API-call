//
//  HomeVC.swift
//  Webservices5_
//
//  Created by Smita Kankayya on 17/01/24.
//

import UIKit
import MapKit
import CoreLocation

class HomeVC: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var usersCV: UICollectionView!
    @IBOutlet weak var populationTV: UITableView!
    
    private let UsersCVCellIdentifier = "UsersCollectionViewCell"
    private let PopulationTVCellIdentifier = "PopulationTableViewCell"
    
    var users : [UsersDM] = []
    var population = PopulationDM(data: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeView()
        registerXIB()
        usersFetchData()
        populationFetchData()
    }
    
    let manager = CLLocationManager()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest     //battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            manager.stopUpdatingLocation()
            
            render(location)
        }
    }
    
    func render(_ location: CLLocation){
        let coordinate = CLLocationCoordinate2D(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinate
        pin.title = "Smita Kankayya"
        mapView.addAnnotation(pin)
        
    }
    
    func initializeView(){
        usersCV.dataSource = self
        usersCV.delegate = self
        populationTV.dataSource = self
        
        
    }
    
    func registerXIB(){
        let uiNib = UINib(nibName: UsersCVCellIdentifier, bundle: nil)
        self.usersCV.register(uiNib, forCellWithReuseIdentifier: UsersCVCellIdentifier)
        let uiNib1 = UINib(nibName: PopulationTVCellIdentifier, bundle: nil)
        self.populationTV.register(uiNib1, forCellReuseIdentifier: PopulationTVCellIdentifier)
        
    }
    
    func usersFetchData(){
        let usersUrl = URL(string: "https://gorest.co.in/public/v2/users")
        var usersUrlRequest = URLRequest(url: usersUrl!)
        usersUrlRequest.httpMethod = "GET"
        
        let usersUrlSession = URLSession(configuration: .default)
        let dataTask = usersUrlSession.dataTask(with: usersUrlRequest) {
            userData, userUrlResponse, userError in
            let usersResponse = try! JSONSerialization.jsonObject(with:userData!) as! [[String:Any]]
            print(usersResponse)
            
            for eachUsersResponse in usersResponse{
                let userDictionary = eachUsersResponse
                let userId = userDictionary["id"] as! Int
                let userName = userDictionary["name"] as! String
                let userGender = userDictionary["gender"] as! String
                
                let userObject = UsersDM(id: userId, name: userName, gender: userGender)
                self.users.append(userObject)
            }
            DispatchQueue.main.async {
                self.usersCV.reloadData()
            }
        }
        dataTask.resume()
    }
    
    func populationFetchData(){
        let populationUrl = URL(string: "https://datausa.io/api/data?drilldowns=Nation&measures=Population")
        let urlRequest = URLRequest(url: populationUrl!)
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            let jsonDecoder = JSONDecoder()
            self.population = try! jsonDecoder.decode(PopulationDM.self, from: data!)
            print(self.population)
            
            DispatchQueue.main.async{
                self.populationTV.reloadData()
            }
        }
        dataTask.resume()
    }
    
}

//MARK: UICollectionViewDataSource
extension HomeVC : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let usersCVCell = self.usersCV.dequeueReusableCell(withReuseIdentifier: UsersCVCellIdentifier, for: indexPath) as? UsersCollectionViewCell
        usersCVCell?.usersId.text = ("Id: \(String(users[indexPath.row].id))")
        usersCVCell?.usersName.text = ("Name: \(users[indexPath.row].name)")
        usersCVCell?.usersGender.text = ("Gender: \(users[indexPath.row].gender)")
        return usersCVCell!
    }
}

//MARK: UICollectionViewDelegateFlowLayout
extension HomeVC : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: usersCV.bounds.size.width, height: 100.0)
    }
}

//MARK: UITableViewDataSource
extension HomeVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        population.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let populationTVCell = self.populationTV.dequeueReusableCell(withIdentifier: PopulationTVCellIdentifier, for: indexPath) as? PopulationTableViewCell
        populationTVCell?.yearLabel.text = ("Year: \(population.data[indexPath.row].Year)")
        populationTVCell?.populationLabel.text = ("Population: \(String(population.data[indexPath.row].Population))")
        return populationTVCell!
    }
    
    
}

