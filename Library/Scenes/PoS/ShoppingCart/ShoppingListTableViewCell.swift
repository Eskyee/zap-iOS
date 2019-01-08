//
//  Library
//
//  Created by Otto Suess on 20.12.18.
//  Copyright © 2018 Zap. All rights reserved.
//

import Bond
import UIKit

class ShoppingListTableViewCell: BondTableViewCell {
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var stepper: UIStepper!
    
    var shoppingCartViewModel: ShoppingCartViewModel?
    var selectedItem: (Product, Observable<Int>)? {
        didSet {
            guard let (product, count) = selectedItem else { return }
            titleLabel.text = product.name
            
            count
                .map { String($0) }
                .bind(to: countLabel.reactive.text)
                .dispose(in: onReuseBag)
            
            updatePrice()
            
            stepper.value = Double(count.value)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        Style.Label.body.apply(to: [countLabel, titleLabel, priceLabel])

        backgroundColor = UIColor.Zap.background
        
        countLabel.font = UIFont.Zap.posCountFont
        countLabel.layer.cornerRadius = 12
        countLabel.backgroundColor = UIColor.Zap.lightningOrange
        countLabel.textColor = .white
        countLabel.clipsToBounds = true
        
        priceLabel.textColor = UIColor.Zap.gray
        
        titleLabel.font = UIFont.Zap.bold.withSize(17)
    }
    
    private func updatePrice() {
        guard let (product, count) = selectedItem else { return }
        let value = product.price * Decimal(count.value)
        priceLabel.text = Settings.shared.fiatCurrency.value.format(value: value)
    }
    
    @IBAction private func stepperChanged(_ sender: UIStepper) {
        guard
            let shoppingCartViewModel = shoppingCartViewModel,
            let (product, _) = selectedItem
            else { return }
        let newValue = Int(sender.value)
        shoppingCartViewModel.setCount(of: product, to: newValue)
        updatePrice()
    }
}