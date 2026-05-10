
---

# 📖 Ethiopian Guenet Church Management System

A modern **Church Management System (ChMS)** built to support the operational, financial, and administrative needs of churches, specifically tailored for Ethiopian Guenet Church.

---

## 🚀 Features

* 👥 Member Management
* 📅 Event & Service Management
* 💰 Financial Management
* 🏢 Department Management
* 📊 Dashboard & Reports
* 🔐 Authentication & Authorization

---

## 🛠️ Tech Stack

* **Frontend:** React.js
* **Backend:** Node.js / Express
* **Database:** MongoDB / MySQL

---

## 📦 Installation

```bash
git clone https://github.com/Genet-Church/Ethiopian-Guenet-Church-Management-System.git
cd Ethiopian-Guenet-Church-Management-System
npm install
npm start
```

---

## 🌐 Live Demo

👉 [https://hundefran.github.io/Ethiopian-Guenet-Church-Management-System-/](https://hundefran.github.io/Ethiopian-Guenet-Church-Management-System-/)

---

# 🔌 API Documentation

## 📍 Base URL

```
http://localhost:5000/api
```

*(Change this when deployed)*

---

## 🔐 Authentication

### Login

```http
POST /auth/login
```

**Request Body**

```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response**

```json
{
  "token": "jwt_token_here",
  "user": {
    "id": "1",
    "name": "Admin"
  }
}
```

---

### Register

```http
POST /auth/register
```

---

## 👥 Members API

### Get All Members

```http
GET /members
```

### Get Single Member

```http
GET /members/:id
```

### Create Member

```http
POST /members
```

**Body**

```json
{
  "name": "John Doe",
  "phone": "0912345678",
  "address": "Addis Ababa"
}
```

### Update Member

```http
PUT /members/:id
```

### Delete Member

```http
DELETE /members/:id
```

---

## 📅 Events API

### Get All Events

```http
GET /events
```

### Create Event

```http
POST /events
```

**Body**

```json
{
  "title": "Sunday Service",
  "date": "2026-05-01",
  "location": "Main Hall"
}
```

---

## 💰 Finance API

### Get Donations

```http
GET /finance/donations
```

### Add Donation

```http
POST /finance/donations
```

**Body**

```json
{
  "memberId": "1",
  "amount": 500,
  "type": "tithe"
}
```

---

## 🏢 Departments API

### Get Departments

```http
GET /departments
```

### Create Department

```http
POST /departments
```

---

## 📊 Reports API

### Get Dashboard Data

```http
GET /reports/dashboard
```

---

## 🔐 Authorization

Include token in headers:

```
Authorization: Bearer your_token_here
```

---

## ⚠️ Error Handling

**Example Response**

```json
{
  "error": "Unauthorized access"
}
```

---

## 🧪 Testing API

You can test endpoints using:

* Postman
* Insomnia
* cURL

---

## 📁 Project Structure

```
src/
 ├── components/
 ├── pages/
 ├── services/
 ├── api/
 ├── assets/
```

---

## 🤝 Contribution

1. Fork the repo
2. Create a branch
3. Commit changes
4. Open Pull Request

---

## 📜 License

MIT License

---

## 📬 Contact

* Email: (your email)
* Organization: Ethiopian Guenet Church

---
