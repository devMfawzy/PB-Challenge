# WorldOfPAYBACK
 WorldOfPAYBACK is an app that allows users to navigate a list of transactions.

## Features
The app consists of two taps; one for showing transactions and each detail, and another tap to provide user settings options.
### Transaction tap
- **Transactions list:** a list of card items that shows `partner display name`, `transaction description`, `booking date`,  `transaction amount`, and `transaction currency`.
- **Loading indicator:** is shown while the transactions list is being loaded.
- **Error View:** is shown whenever a transaction service fails with an error, the user can tap retry for another fetch attempt.  
- **Transaction Filter:** allows the user to filter the loaded transactions by `transactions category`.
- **Transactions Header:** a header view that shows details of filtered transactions the `Sum of transactions amount` and `selected Category`, alongside a reset button for resetting the filter.
- **Pull to refresh:** The user can pull the transaction list to load fresh data.
- **Transaction Details:** The user can tap any transaction card/cell to navigate to the details view which shows `partner display name` and `transaction description`.
### Settings tap
- **Appearance:** allows the user to switch between dark and light mode and persisting user selections.
- **Developer tools:** a section available only in `DEBUG` mode that allows the user to select from `Production`, `Test`, and `Moch` environments.
The app shows a global **"No-Internet-Connection"** view whenever the device becomes offline.

## Setup
1. Check out repository https://github.com/devMfawzy/PB-Challenge.
1. Open `WorldOfPAYBACK.xcodeproj` file.
1. Select the `WorldOfPAYBACK1 Scheme in Xcode and run the app.

## App Architecture
The app follows the `MVVM` Architecture and uses the new `iOS 17.0+` @Observable macro.

## Testing
Added units tests that cover `TransactionList View/ViewModel` and `Transactions Sevice`

## Localization
Using Xcode localizable string catalog for localization.
 - **NOTE:** In production Apps we can use Backend service, or on shelf ones like APPlanga to control the localization process, so POs and translators can update their copies without the need for new release
 - **Localized languages:**
   - English
   - German
   - Frensh









