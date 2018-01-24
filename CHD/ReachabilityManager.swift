//
//  ReachabilityManager.swift
//  CHD2
//
//  Created by CenSoft on 19/07/17.
//  Copyright © 2017 CenSoft. All rights reserved.
//

import UIKit
import ReachabilitySwift

struct Network {
    static var reachability: Reachability?
    enum Status: String, CustomStringConvertible {
        case unreachable, wifi, wwan
        var description: String { return rawValue }
    }
    enum Error: Swift.Error {
        case failedToSetCallout
        case failedToSetDispatchQueue
        case failedToCreateWith(String)
        case failedToInitializeWith(sockaddr_in)
    }
}

class ReachabilityManager: NSObject {


    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var window = UIWindow()
    static  let shared = ReachabilityManager()
    var isReachable = Bool()
    var snackBar: UIView!
    
    // 3. Boolean to track network reachability
    var isNetworkAvailable : Bool {
        return reachabilityStatus != .notReachable
    }
    // 4. Tracks current NetworkStatus (notReachable, reachableViaWiFi, reachableViaWWAN)
    var reachabilityStatus: Reachability.NetworkStatus = .notReachable
    // 5. Reachability instance for Network status monitoring
    let reachability = Reachability()!
    
    /// Called whenever there is a change in NetworkReachibility Status
    ///
    /// — parameter notification: Notification with the Reachability instance
    @objc func reachabilityChanged(notification: Notification) {
        let reachability = notification.object as! Reachability

        switch reachability.currentReachabilityStatus {
        case .notReachable:
            debugPrint("Network became unreachable")
            DispatchQueue.main.async {
                self.addSnackBar(isConnected: false)
            }
        case .reachableViaWiFi:
             debugPrint("Network reachable through WiFi")
            DispatchQueue.main.async {
                self.addSnackBar(isConnected: true)
            }
        case .reachableViaWWAN:
            DispatchQueue.main.async {
                self.addSnackBar(isConnected: true)

            }
            debugPrint("Network reachable through Cellular Data")
        }
    }

    func addSnackBar(isConnected: Bool) {
        window = appDelegate.window!
        if snackBar != nil {
            self.snackBar.removeFromSuperview()
        }
        //snackBar = UIView()

        snackBar = {
            let bar = UIView()
            bar.frame.size = CGSize(width: window.frame.width, height: 50)
            bar.backgroundColor = .black

            let tick = UIImageView()
            tick.image = #imageLiteral(resourceName: "icons8-delete-100")
            tick.frame = CGRect(x: 20, y: 16, width: 20, height: 20)
            bar.addSubview(tick)

            let label = UILabel()
            label.text = "You are not connected to internet."
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 13)
            label.frame = CGRect(x: 50, y: 16, width: 300, height: 20)
            bar.addSubview(label)
            return bar
        }()

        if isConnected {
            snackBar.frame.origin.y = window.frame.height - 50
        } else {
            snackBar.frame.origin.y = window.frame.height
        }
        snackBar.frame.origin.x = 0
        window.addSubview(snackBar)

        if isConnected {
            UIView.animate(withDuration: 0.5, animations: {
                self.snackBar.frame.origin.y = self.window.frame.height

            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.snackBar.frame.origin.y = self.window.frame.height - 50

            })
        }
    }
    
    /// Starts monitoring the network availability status
    func startMonitoring() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.reachabilityChanged),
                                               name: ReachabilityChangedNotification,
                                               object: reachability)
        do{
            try reachability.startNotifier()
        } catch {
            debugPrint("Could not start reachability notifier")
        }
    }
    
    /// Stops monitoring the network availability status
    func stopMonitoring(){
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self,
                                                  name: ReachabilityChangedNotification,
                                                  object: reachability)
    }
}
