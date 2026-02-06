# URL utilisées par mounir le 27 janvier

- https://ui.qetv4-onl-author-release.andromede.pwcv4.com/#/login
- https://ui.qetv4-onl-author-release.andromede.pwcv4.com/#/param/home
- https://ui.qetv4-onl-author-release.andromede.pwcv4.com/#/op/dashboard


# URLs des écrans à tester

## Module ACQUIRING

### Écran : Merchant Subscription
- **URL** : `***#/op/acquiring/merchantSubscription`
- **Route** : `{ path: 'merchantSubscription', loadChildren: './product/merchant_subscription/merchantSubscription.module#MerchantSubscriptionModule' }`

### Écran : Contract Subscription
- **URL** : `***#/op/acquiring/contratSubscription`
- **Route** : `{ path: 'contratSubscription', loadChildren: './product/contrat_subscription/contratSubscription.module#ContratSubscriptionModule' }`

### Écran : Transactions
- **URL** : `***#/op/acquiring/transactionHist`
- **Route** : `{ path: 'transactionHist', loadChildren: './product/transaction_hist/transactionHist.module#TransactionHistModule' }`

### Écran : Dispute Case
- **URL** : `***#/op/acquiring/Case_table`
- **Route** : `{ path: 'Case_table', loadChildren: './product/caseManagement/case-table/case-table.module#CaseTableModule' }`

### Écran : Visa Fees
- **URL** : `***#/op/acquiring/visaFees`
- **Route** : `{ path: 'visaFees', loadChildren: './product/visaFees/visaFees.module#VisaFeesModule' }`

### Écran : Exchange Scenario
- **URL** : `***#/param/acquiring/scenario-echange`
- **Route** : `{ path: 'scenario-echange', loadChildren: './product/scenario-echange/scenarioEchange.module#ScenarioEchangeModule' }`

---

## Module ISSUING

### Écran : Boarding
- **URL** : `***#/op/issuing/boarding`
- **Route** : `{ path: 'boarding', loadChildren: './product/boarding/boarding.module#BoardingModule' }`

### Écran : Catalog
- **URL** : `***#/param/issuing/catalogue`
- **Route** : `{ path: 'catalogue', loadChildren: './product/catalogue/catalogue.module#CatalogueModule' }`

### Écran : Payment Instrument
- **URL** : `***#/op/issuing/payment-instruments`
- **Route** : `{ path: 'payment-instruments', loadChildren: './product/payment-instruments/payment-instruments.module#PaymentInstrumentsModule' }`

### Écran : Customer View
- **URL** : `***#/op/issuing/customer-view`
- **Route** : `{ path: 'customer-view', loadChildren: './product/customer-view/customerView.module#CustomerViewModule' }`

---

## Module SWITCH

### Écrans complexes

#### Screen : Authorization List
- **URL** : `***#/op/switch/authorization_list`
- **Route** : `{ path: 'authorization_list', loadChildren: './authorization/authorization-list/authorizationList.module#AuthorizationListModule' }`

#### Screen : PAN Limits
- **URL** : `***#/op/switch/p7-pan-limits-setup`
- **Route** : `{ path: 'p7-pan-limits-setup', loadChildren: './activity/p7-pan-limits-setup/p7PanLimitsSetup.module#P7PanLimitsSetupModule' }`

#### Screen : Fraud Case
- **URL** : `***#/op/fraud/frd-case`
- **Route** : `{ path: 'frd-case', loadChildren: './frd-case/frdCase.module#FrdCaseModule' }`

#### Screen : Switch Activity
- **URL** : `***#/op/switch/switch_monitoring_activity`
- **Route** : `{ path: 'switch_monitoring_activity', loadChildren: './monitoring/charts/switch-monitoring-activity/switch-monitoring-activity.module#SwitchMonitoringActivityModule' }`

#### Screen : Resource Definition
- **URL** : `***#/param/switch/definition`
- **Route** : `{ path: 'definition', loadChildren: './resource/resources/resources.module#ResourcesModule' }`

### Écrans de complexité moyenne

#### Screen : Stop List Card Bin Range
- **URL** : `***#/op/switch/stpl-card-bin-range`
- **Route** : `{ path: 'stpl-card-bin-range', loadChildren: './stoplist/stop-list-card-bin-range/stopListCardBinRange.module#StopListCardBinRangeModule' }`

#### Screen : Network Message
- **URL** : `***#/op/switch/network-msg-log`
- **Route** : `{ path: 'network-msg-log', loadChildren: './authorization/network-msg-log/networkMsgLog.module#NetworkMsgLogModule' }`
