# Product Requirements Document: Yegna Eqif

## 1. Introduction

Yegna Eqif is a personal finance management application designed to help users track their income, expenses, and savings. It provides a comprehensive suite of tools for budgeting, financial planning, and analyzing spending habits. The app is built with Flutter and utilizes Firebase for its backend services.

## 2. Features

### 2.1. User Authentication

*   **Sign-in:** Users can sign in with their email and password.
*   **Sign-up:** New users can create an account by providing their name, email, and a password.
*   **Password Reset:** Users can reset their password if they forget it.
*   **Splash Screen:** A loading screen is displayed while checking the user's authentication state.

### 2.2. Dashboard

*   **Overview:** The dashboard provides a snapshot of the user's financial health, including their total balance, recent transactions, and a summary of their spending.
*   **Top Spending:** Displays the categories where the user has spent the most money.

### 2.3. Transactions

*   **Add Transaction:** Users can add new transactions, specifying the amount, category, date, and a description.
*   **Transaction List:** A list of all transactions, which can be filtered by date, category, and type (income or expense).
*   **Transaction Details:** Detailed view of a single transaction.

### 2.4. Budget

*   **Create Budget:** Users can create budgets for different categories on a monthly or yearly basis.
*   **Budget Tracking:** The app tracks spending against the budget and notifies the user if they are close to exceeding it.

### 2.5. Bank Cards

*   **Add Card:** Users can add their bank cards to the app for easier transaction entry.
*   **Card List:** A list of all added cards.

### 2.6. Debt

*   **Add Debt:** Users can track money they owe or are owed.
*   **Debt List:** A list of all debts, with their current status.

### 2.7. Reports

*   **Spending by Category:** A breakdown of spending by category over a selected period.
*   **Income vs. Expense:** A comparison of income and expenses over time.

### 2.8. Categories

*   **Default Categories:** The app comes with a set of default categories for income and expenses.
*   **Custom Categories:** Users can create their own custom categories.

### 2.9. Settings

*   **Profile:** Users can view and edit their profile information.
*   **Theme:** The app supports both light and dark themes.
*   **Notifications:** Users can configure their notification preferences.

## 3. Architecture and Technology

*   **MVVM Architecture:** The app follows the Model-View-ViewModel (MVVM) design pattern to separate the business logic from the UI.
*   **Provider for State Management:** The Provider package is used for state management, allowing for efficient and predictable state changes.
*   **Firebase Backend:**
    *   **Authentication:** Firebase Authentication is used for user management.
    *   **Firestore:** Cloud Firestore is used as the database for storing all user data.
    *   **Cloud Storage:** Firebase Cloud Storage is used for storing user-generated content, such as profile pictures.

## 4. User Data

User data is stored in a `users` collection in Firestore. Each user has a document with their user ID, which contains their profile information, transactions, budgets, and other data.

## 5. Future Work

*   **Enhanced Security:** Implement two-factor authentication (2FA) for added security.
*   **Detailed Reports:** Add more detailed reports and visualizations to help users better understand their finances.
*   **Bank Integration:** Integrate with financial institutions to automatically import transactions.
*   **Multi-language Support:** Add support for multiple languages to make the app accessible to a wider audience.
