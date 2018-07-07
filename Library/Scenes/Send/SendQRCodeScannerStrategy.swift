//
//  Zap
//
//  Created by Otto Suess on 25.04.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import BTCUtil
import Foundation
import Lightning

class SendQRCodeScannerStrategy: QRCodeScannerStrategy {
    let title = "scene.deposit.send".localized
    let transactionAnnotationStore: TransactionAnnotationStore
    var lastScannedAddress: String?
    
    init(transactionAnnotationStore: TransactionAnnotationStore) {
        self.transactionAnnotationStore = transactionAnnotationStore
    }
    
    func viewControllerForAddress(address: String, lightningService: LightningService) -> Result<UIViewController>? {
        guard address != lastScannedAddress else { return nil }
        lastScannedAddress = address
        
        let sendViewModel = SendViewModel(lightningService: lightningService)
        let result = sendViewModel.paymentURI(for: address)
        
        return result.map {
            if let bitcoinURI = $0 as? BitcoinURI {
                let sendOnChainViewModel = SendOnChainViewModel(lightningService: lightningService, bitcoinURI: bitcoinURI)
                return UIStoryboard.instantiateSendOnChainViewController(with: sendOnChainViewModel)
            } else if let lightningURI = $0 as? LightningInvoiceURI {
                let sendLightningInvoiceViewModel = SendLightningInvoiceViewModel(transactionAnnotationStore: transactionAnnotationStore, transactionService: lightningService.transactionService, lightningInvoice: lightningURI.address)
                return UIStoryboard.instantiateSendLightningInvoiceViewController(with: sendLightningInvoiceViewModel)
            } else {
                fatalError("No ViewController implemented for URI")
            }
        }
    }
}
