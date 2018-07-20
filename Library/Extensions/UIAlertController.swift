//
//  Zap
//
//  Created by Otto Suess on 12.06.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Lightning
import UIKit

extension UIAlertController {
    static func closeChannelAlertController(channel: Channel, nodeAlias: String, closeAction: @escaping () -> Void) -> UIAlertController {
        let title: String
        let message: String
        
        if channel.state == .active {
            title = "scene.channels.close.title".localized
            message = String(format: "scene.channels.close.message".localized, nodeAlias)
        } else {
            title = "scene.channels.force_close.title".localized
            
            let formatter = DateComponentsFormatter()
            formatter.allowedUnits =  [.year, .month, .day, .hour, .minute]
            formatter.unitsStyle = .full
            formatter.maximumUnitCount = 2
            
            let blockTime: TimeInterval = 10 * 60
            let timeUntilClose = formatter.string(from: TimeInterval(channel.csvDelay) * blockTime) ?? ""
            
            message = String(format: "scene.channels.force_close.message".localized, nodeAlias, timeUntilClose)
        }
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAlertAction = UIAlertAction(title: "scene.channels.alert.cancel".localized, style: .cancel, handler: nil)
        let closeAlertAction = UIAlertAction(title: "scene.channels.alert.close".localized, style: .destructive) { _ in
            closeAction()
        }
        alertController.addAction(cancelAlertAction)
        alertController.addAction(closeAlertAction)
        
        return alertController
    }
}
