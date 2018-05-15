//
//  Forecasts.swift
//  ClearSky
//
//  Created by Marcin Czachurski on 14.05.2018.
//  Copyright © 2018 Marcin Czachurski. All rights reserved.
//

import UIKit

class ForecastsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelOutlet: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInitialization()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInitialization()
    }

    private func commonInitialization() {
        Bundle.main.loadNibNamed("Forecasts", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
