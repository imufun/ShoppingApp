import UIKit

class SearchViewController: DetailViewController, UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    

    let model = SingletonManager.model
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var data = ["dogs", "Cats", "Goofs", "Apples", "Frogs", "Orange"]
    
    var filteredData = [String]()
    
    var inSearchMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureCollectionView()
        
        searchBar.delegate = self
        
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    // MARK: - UICollectionViewSource
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DataCell {
            
            let text: String!
            
            if inSearchMode {
                
                text = filteredData[indexPath.row]
                
            } else {
                
                text = data[indexPath.row]
            }
            
            cell.congigureCell(text: text)
            
            return cell
            
        } else {
            
            return UITableViewCell()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == nil || searchBar.text == "" {
            
            inSearchMode = false
            
            view.endEditing(true)
            
        } else {
            
            inSearchMode = true
            
            filteredData = data.filter({$0 == searchBar.text})
            
        }
    }

    
    func configureCollectionView() {
        self.collectionView!.dataSource = self
        self.collectionView!.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Find out what row was selected
        let indexPath = self.collectionView?.indexPath(for: sender as! Cell)
        
        //sender as? NSIndexPath
        
        // Grab the detail view
        let detailView = (segue.destination as! UINavigationController).topViewController as! ProductViewController
        
        // Get the selected cell's image
        let product = model.products[indexPath!.row]
        
        // Pass the content to the detail view
        detailView.productItem = product
        
        // Set up navigation on detail view
        detailView.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem
        detailView.navigationItem.leftItemsSupplementBackButton = true
        
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! Cell
        cell.cellImageView.image = model.products[indexPath.row].image
        cell.cellLabel.text = model.products[indexPath.row].name
        if let label = cell.cellPriceLabel {
            label.text = "$" + model.products[indexPath.row].price
        }
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }
    
    // MARK: addItemToCart
    
    @IBAction func addItemToCart(_ sender: Any) {
        //model.addItemToCart(model.)
    }
}
