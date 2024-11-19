# TaskMate

## Description
TaskMate is a Flutter-based application designed to help users manage their tasks and notes efficiently. With a user-friendly interface and robust features, TaskMate allows users to create, edit, and organize notes while keeping track of their tasks based on deadlines. The app integrates Firebase for authentication and data storage, ensuring a seamless experience across devices.

## Table of Contents
- [Features](#features)
- [Screenshots](#screenshots)
- [Technologies Used](#technologies-used)
- [Firebase Data Storage](#firebase-data-storage)
- [Installation Instructions](#installation-instructions)
- [Usage](#usage)
- [User  Lessons](#user-lessons)
- [Contributing](#contributing)
- [License](#license)
- [Contact Information](#contact-information)
- [Acknowledgements](#acknowledgements)

## Features
- **User  Authentication**: Sign up and log in using Firebase Authentication with validation, including regex constraints for email and password.
- **Note Section**:
  - Create, edit, and delete notes.
  - Search functionality to find notes quickly.
  - Mark notes as favorites.
  - Share notes with others.
- **Task Section**:
  - Create, edit, and delete tasks.
  - Task management based on calendar dates and timelines.
  - Generate reports of tasks.
- **Profile Management**: Update profile picture, username, and profession.
- **Settings**:
  - Change app theme.
  - Backup data to Firebase.
  - Notification settings.
- **Local Database**: Utilizes SQFlite for local data storage, ensuring offline access to notes and tasks.

## Screenshots






![welcome.png](../_resources/welcome.png)
![singup.png](../_resources/singup.png)



![signin.png](../_resources/signin.png)


![homePage.png](../_resources/homePage.png)



![createtask.png](../_resources/createtask.png)

![menubar.png](../_resources/menubar.png)
![profile.png](../_resources/profile.png)

![updatemnubar.png](../_resources/updatemnubar.png)



![timeline.png](../_resources/timeline.png)





![hompage with task.png](../_resources/hompage%20with%20task.png)
![alltask_page.png](../_resources/alltask_page.png)


![task staroption.png](../_resources/task%20staroption.png)







![setting.png](../_resources/setting.png)



![searchtask.png](../_resources/searchtask.png)



![report.png](../_resources/report.png)






![option.png](../_resources/option.png)



![notification.png](../_resources/notification.png)



![notepage.png](../_resources/notepage.png)


![withsinglenote.png](../_resources/withsinglenote.png)


![create note.png](../_resources/create%20note.png)








## Technologies Used
- Flutter
- Dart
- Firebase (for authentication and data storage)
- SQFlite (for local database)

## Firebase Data Storage
TaskMate uses Firebase Firestore as the primary data storage solution. Key features include:
- **Real-time Data Sync**: Changes made to notes or tasks are instantly reflected across all devices.
- **Data Structure**:
  - **Users Collection**: Stores user profiles, including username, profile picture, and profession.
  - **Notes Collection**: Each note is stored with fields for title, content, timestamp, and user ID.
  - **Tasks Collection**: Each task includes fields for title, description, due date, status, and user ID.
- **Security Rules**: Firebase security rules ensure that users can only access their own data, providing a secure environment for personal information.

## Installation Instructions
1. **Prerequisites**:
   - Ensure you have Flutter SDK installed on your machine.
   - Install Dart SDK if it's not bundled with Flutter.
   - Set up a Firebase project and enable Firestore and Authentication.
  
2. **Clone the repository**:
   ```bash
   git clone https://github.com/alamin_al_shaharia/taskmate.git