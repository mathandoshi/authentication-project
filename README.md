
# Authentication Project

## Overview

This project is a full-stack Authentication System built using Flutter and Django REST Framework.

The application provides secure user authentication using Email OTP verification and JWT authentication. Users can register, log in, verify their email using OTP, reset forgotten passwords, and access protected screens after authentication.

---

## Features

### User Registration

* Create a new account
* Email-based registration
* OTP sent to registered email
* Account activation after OTP verification

### User Login

* Login with username and password
* OTP verification after login
* Secure authentication flow

### Email OTP Verification

* Generate OTP
* Send OTP through email
* Verify OTP before granting access

### Forgot Password

* Request password reset using email
* Receive OTP via email
* Reset password securely

### JWT Authentication

* Access token generation
* Secure API communication
* Token storage on device

---

## Technology Stack

### Frontend

* Flutter
* Dart

### Backend

* Django
* Django REST Framework
* Simple JWT

### Database

* SQLite

### Authentication

* Email OTP Verification
* JWT Tokens

---

## Project Structure

Authentication_Project/

├── auth_app/

│ └── flutter_application_1/

│ ├── lib/

│ ├── screens/

│ ├── services/

│ └── main.dart

│

├── auth_backend/

│ ├── accounts/

│ ├── config/

│ ├── manage.py

│ └── db.sqlite3

│

└── README.md

---

## API Endpoints

### Register

POST

/api/register/

### Login

POST

/api/login/

### Send OTP

POST

/api/send-otp/

### Verify OTP

POST

/api/verify-otp/

### Forgot Password

POST

/api/forgot-password/

### Reset Password

POST

/api/reset-password/

---

## Installation

### Backend Setup

```bash
cd auth_backend

pip install -r requirements.txt

python manage.py migrate

python manage.py runserver
```

### Flutter Setup

```bash
cd auth_app/flutter_application_1

flutter pub get

flutter run
```

---

## Author

Manthan Doshi

B.Tech Student

Flutter + Django Authentication Project

\# Authentication Project



\## Overview



This project is a full-stack Authentication System built using Flutter and Django REST Framework.



The application provides secure user authentication using Email OTP verification and JWT authentication. Users can register, log in, verify their email using OTP, reset forgotten passwords, and access protected screens after authentication.



\---



\## Features



\### User Registration



\* Create a new account

\* Email-based registration

\* OTP sent to registered email

\* Account activation after OTP verification



\### User Login



\* Login with username and password

\* OTP verification after login

\* Secure authentication flow



\### Email OTP Verification



\* Generate OTP

\* Send OTP through email

\* Verify OTP before granting access



\### Forgot Password



\* Request password reset using email

\* Receive OTP via email

\* Reset password securely



\### JWT Authentication



\* Access token generation

\* Secure API communication

\* Token storage on device



\---



\## Technology Stack



\### Frontend



\* Flutter

\* Dart



\### Backend



\* Django

\* Django REST Framework

\* Simple JWT



\### Database



\* SQLite



\### Authentication



\* Email OTP Verification

\* JWT Tokens



\---



\## Project Structure



Authentication\_Project/



├── auth\_app/



│ └── flutter\_application\_1/



│ ├── lib/



│ ├── screens/



│ ├── services/



│ └── main.dart



│



├── auth\_backend/



│ ├── accounts/



│ ├── config/



│ ├── manage.py



│ └── db.sqlite3



│



└── README.md



\---



\## API Endpoints



\### Register



POST



/api/register/



\### Login



POST



/api/login/



\### Send OTP



POST



/api/send-otp/



\### Verify OTP



POST



/api/verify-otp/



\### Forgot Password



POST



/api/forgot-password/



\### Reset Password



POST



/api/reset-password/



\---



\## Installation



\### Backend Setup



```bash

cd auth\_backend



pip install -r requirements.txt



python manage.py migrate



python manage.py runserver

```



\### Flutter Setup



```bash

cd auth\_app/flutter\_application\_1



flutter pub get



flutter run

```



\---



\## Author



Manthan Doshi



B.Tech Student



Flutter + Django Authentication Project



