# Recipe Roulette

Recipe Roulette is an iOS recipe discovery application built with Swift and SwiftUI. The app helps users explore recipes, view cooking details, and save their favorite meals through an intuitive mobile interface.

## Features

- **Recipe Discovery:** Explore recipes using data retrieved from a recipe API.
- **Recipe Details:** View recipe information through dedicated detail screens.
- **Favorites:** Save and revisit favorite recipes.
- **Customizable Settings:** Access app preferences through a dedicated settings interface.
- **Multilingual Support:** Includes localization resources for English, Spanish, and French.
- **Native iOS Interface:** Built with SwiftUI for a consistent Apple-platform experience.

## Technologies Used

- Swift
- SwiftUI
- Xcode
- REST API Integration
- MVVM Architecture
- iOS Localization

## Project Structure

- `ContentView.swift` — Main application interface
- `RecipeAPI.swift` — Recipe API integration
- `Recipe.swift` — Recipe data model
- `RecipeViewModel.swift` — Recipe state and application logic
- `RecipeView.swift` — Recipe presentation
- `DetailsView.swift` — Detailed recipe interface
- `FavoritesView.swift` — Favorites interface
- `SettingsView.swift` — Application settings
- `NotificationManager.swift` — Notification-related functionality
- `Assets.xcassets` — App icons and visual assets

## Getting Started

1. Clone the repository:

   ```bash
   git clone https://github.com/mhenry27/Recipe-Roulette-iOS.git
   ```

2. Open `Recipe Roulette.xcodeproj` in Xcode.
3. Select an available iOS simulator.
4. Build and run the project.

An internet connection may be required for recipe data retrieval.

## Future Improvements

- Expand recipe filtering and search capabilities.
- Improve favorites management and persistence.
- Add automated unit and UI tests.
- Enhance accessibility and user personalization.

## Author

Mackinley Henry  
Computer Science, University of Rochester — Class of 2027
