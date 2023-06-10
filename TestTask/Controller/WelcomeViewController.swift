//
//  ViewController.swift
//  TestTask
//

import UIKit
import MBProgressHUD

class WelcomeViewController: UIViewController {
    private var welcomeData: [WelcomeModel] = []
    private var pageCount: Int = 1
    private var isLoading: Bool = false
    private var refreshControl = UIRefreshControl()
    private var selectedArray: [IndexPath] = []


    @IBOutlet weak var tableView: UITableView! {
        didSet {
            self.tableView.separatorStyle = .none
            self.tableView.estimatedRowHeight = 44
            self.tableView.backgroundColor = .clear
            self.tableView.refreshControl = refreshControl
            self.refreshControl.tintColor = .clear
            self.tableView.register(UINib(nibName: "WelocmeTableViewCell", bundle: nil), forCellReuseIdentifier: "welocmeTableViewCell")
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl.addTarget(self, action: #selector(didReloadController(_:)), for: .valueChanged)
        
        //call api when loads
        getAuthorData()
    }
    
  
}


// MARK: - Private Func

extension WelcomeViewController {
    
    // handle for refreshing data
     @objc func didReloadController(_ sender: UIRefreshControl?) {
        //Handle in resepected controllers
        self.resetProductListContent()
        self.getAuthorData()
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
        }
    }
    
    //reset the data when user make pull to refresh
    private func resetProductListContent() {
        self.pageCount = 1
        self.welcomeData = []
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate


extension WelcomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.welcomeData.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "welocmeTableViewCell") as? WelocmeTableViewCell
        cell?.updateCellInfo(indexPath, delegate: self)
        cell?.configureModel(with: welcomeData[indexPath.row], isSelcted: self.selectedArray.contains(indexPath))
        return cell ?? UITableViewCell()
    }
}

// MARK: - API

extension WelcomeViewController {
    private func getAuthorData() {
        MBProgressHUD.showAdded(to: view, animated: true)
        APICaller.shared.getData(pageCount: self.pageCount) { [weak self] result in
            guard let self = self else {
                return
            }

            DispatchQueue.main.async {
                self.isLoading = false
                MBProgressHUD.hide(for: self.view, animated: true)
                switch result {
                case .success(let model):
                    self.welcomeData.append(contentsOf: model)
                    self.tableView.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}


// MARK: - UIScrollViewDelegate
extension WelcomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yAixsOffset = scrollView.contentOffset.y + scrollView.frame.size.height
        if (yAixsOffset > scrollView.contentSize.height), !self.isLoading {
            self.isLoading = true
            self.pageCount = self.pageCount + 1
            
            //Calling getAuthorData API
            self.getAuthorData()
        }
    }
}


// MARK: - WelocmeTableViewCellDelegate
extension WelcomeViewController: WelocmeTableViewCellDelegate {
    func didTapcheckbox(_ indexpath: IndexPath, sender: UIButton) {
        if selectedArray.contains(indexpath) {
            let alert = UIAlertController(title: "Deselect", message: "Do you wants to deselect", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "yes", style: .default, handler: {_ in
                self.selectedArray.removeAll(where: { $0 == indexpath} )
                self.tableView.reloadData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else {
           let alert = UIAlertController(title: "Selection", message: "would you like to select author?", preferredStyle: .alert)
           alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { action in
               self.selectedArray.append(indexpath)
               self.tableView.reloadData()
           }))
           alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: { _ in
               sender.isSelected = !sender.isSelected
           }))
           present(alert, animated: true)
        }
    }
}
