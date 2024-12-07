Team02 WeEvent
=======================

A mobile application designed for seamless event management, recipe sharing, and ingredient assignment. Built with **Swift** and **Firebase**, this app is tailored to enhance group gatherings by organizing recipes, assigning tasks, and managing event-related details efficiently.

* * * * *

📋 Features
-----------

### Event Management

-   Create and manage events.
-   Assign recipes and tasks to friends.
-   Track ingredient contributions for gatherings.

### Recipe Sharing

-   Explore recommended recipes by category.
-   Like recipes and view them in a personalized collection.
-   View detailed recipe instructions, ingredients, and cooking time.

### User Interaction

-   Add friends and collaborate on event planning.
-   Real-time updates with Firebase integration.

* * * * *

🛠️ Technologies Used
---------------------

### Frontend

-   **SwiftUI**: For building a modern and responsive UI.
-   **Swift**: Language for implementing business logic and data handling.
-   **MVVM Design Pattern**: Ensures a clear separation of concerns between UI and data.

### Backend

-   **Firebase Realtime Database**: For real-time data synchronization.
-   **Firebase Authentication**: For secure user login and management.

### Tools & Packages

-   **Xcode**: IDE for development and debugging.
-   **Firebase Realtime Database:** Used for persisting event, user, and recipe data.
    - **FirebaseAuth:** Handles user authentication and security rules.
    - **FirebaseCore:** Provides the core infrastructure needed for Firebase services.
    - **FirebaseDatabase:** Integrates with the Firebase Realtime Database for storing and syncing data.
    - **FirebaseFirestore:** Leverages the Firestore service for flexible, scalable, and real-time document storage.

* * * * *
## Known Issues & Reminders for TA
1. **Event Creation and Invitations:**  
   After creating a new event, **please remember to invite yourself** to the event. This step ensures proper data access within the app for demonstration and testing purposes.

2. **Recipe Search Page Issue in Event Detail:**  
   A minor UI bug displays an unintended "cancel" text due to API configuration issues. While we couldn’t fully debug this, it does not affect the functionality. You can still search and select recipes without issues.

3. **Ingredient Assignment Refreshing:**  
   When assigning ingredients to a user, the changes appear in the upcoming event to-do section on the home page. However, **auto-refresh is not working**. To see updated assignments, **quit and re-enter the app**. We acknowledge this inconvenience and were unable to resolve it in time.

4. **Cost Page Calculation Bug:**
   The cost page cannot displays the "you are owed" and "you owe" values. While adding and viewing costs is fully functional, the display labels may be misleading. We couldn’t fully debug this issue before submission.

**In summary,** while the app’s core functionality is intact and models are thoroughly tested, there are known issues with ViewModel testing, some UI bugs, and refresh limitations. We recommend following the setup instructions carefully and keeping these known issues in mind when demonstrating or reviewing the app.

* * * * *

🚀 Getting Started
------------------

### Prerequisites

-   **macOS** with the latest version of **Xcode** installed.
-   **Firebase Project Setup**:
    -   Add your `GoogleService-Info.plist` file to the project.
    -   Enable Realtime Database and Authentication in Firebase Console.

### Installation

1.  Clone the repository:

    ```bash
    git clone https://github.com/ruiminggu/67443-Team02-EventManagement.git

2.  Open the project in **Xcode**:

    ```bash
    open Team02.xcodeproj
    
3.  Add your `GoogleService-Info.plist` file to the project root.
4. If using CocoaPods, run `pod install` in the project directory. Otherwise, ensure Swift Package Manager dependencies are resolved.
5.  Run the app on a simulator or a physical device.

* * * * *

📂 Project Structure
--------------------

```bash
67443-Team02-EventManagement/
├── Team02/
│   ├── Models/            # Swift model files (e.g., Recipe, Event, Ingredient)
│   ├── Views/             # SwiftUI views for UI components
│   ├── ViewModels/        # MVVM ViewModels for data management
│   ├── Resources/         # Assets and supporting files
│   └── Firebase/          # Firebase integration and database handling
├── Tests/                 # Unit tests for models and ViewModels
└── README.md              # Project documentation
```

* * * * *


🧪 Testing Issues
----------------
- **Model Testing:**  
  We have achieved at least **90% test coverage for each model**. This ensures that our core data structures and logic are well-validated.

- **ViewModel Testing:**  
While we aimed to apply a similar level of test coverage to our ViewModels, we encountered significant challenges in mocking the Firebase database references and could not implement these tests as intended. As a result, no ViewModel tests were included in this release, and coverage for this layer remains unmeasured.

To run unit tests:

1.  Open the project in Xcode.
2.  Select the **Team02Tests** target.
3.  Press `Cmd + U` or go to **Product > Test**.

* * * * *
🤝 Acknowledgments
------------------

This project was made possible through the collaborative effort of our amazing team:

-   **Ruiming Gu** (GitHub Profile: [ruiminggu](https://github.com/ruiminggu))
-   **Leila Lei**
-   **Erin Chen**

Thank you for your hard work, creativity, and dedication to making this project a success!

This README was initially drafted and later refined with the assistance of ChatGPT.
* * * * *

📧 Contact
----------

If you have any questions or suggestions, feel free to reach out to the repository owner:

**Ruiming Gu**

-   [GitHub Profile](https://github.com/ruiminggu)

