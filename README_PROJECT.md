# Store Rating Application

A Ruby on Rails web application that enables users to submit ratings for stores registered on the platform. The application supports three types of users with different roles and functionalities.

## Features

### User Roles
- **System Admin**: Manages users, stores, and views comprehensive statistics
- **Normal User**: Can signup, login, view stores, and submit/modify ratings
- **Store Owner**: Can login, view their store dashboard, and see ratings from users

### Core Functionalities

#### System Admin
- Dashboard with statistics (Total Users, Total Stores, Total Ratings)
- Add/manage stores, normal users, and admin users
- View all user types with filtering and sorting capabilities
- User management with full CRUD operations

#### Normal User
- Signup and login functionality
- Password change capability
- View list of all registered stores with search functionality
- Submit ratings (1-5) for stores
- Modify existing ratings
- Search stores by name and address

#### Store Owner
- Login functionality
- Password change capability
- Dashboard showing users who rated their store
- View average ratings for their store
- Statistics and analytics for their store

## Technical Specifications

### Technology Stack
- **Framework**: Ruby on Rails 7.1.5
- **Database**: SQLite3
- **Authentication**: Custom implementation with bcrypt
- **Ruby Version**: 3.0.2

### Database Schema
- **Users**: name, email, password_digest, address, role, timestamps
- **Stores**: name, email, address, user_id (foreign key), timestamps
- **Ratings**: user_id (foreign key), store_id (foreign key), rating, timestamps

### Validations
- **Name**: 20-60 characters (min-max)
- **Address**: Maximum 400 characters
- **Password**: 8-16 characters with at least 1 uppercase letter and 1 special character
- **Email**: Valid email format with uniqueness
- **Rating**: Integer between 1-5

## Installation and Setup

### Prerequisites
- Ruby 3.0.2
- Rails 7.1.5
- SQLite3
- Bundler

### Setup Instructions

1. **Install Dependencies**
   ```bash
   bundle install
   ```

2. **Setup Database**
   ```bash
   rails db:migrate
   rails db:seed
   ```

3. **Start the Server**
   ```bash
   rails server
   ```

4. **Access the Application**
   - Open browser and navigate to `http://localhost:3000`

### Test Accounts




#### Normal Users
- Email: `user1@example.com` | Password: `User123!`
- Email: `user2@example.com` | Password: `User123!`
- Email: `user3@example.com` | Password: `User123!`
- Email: `user4@example.com` | Password: `User123!`
- Email: `user5@example.com` | Password: `User123!`

## Project Structure

```
store_rating_app/
├── app/
│   ├── controllers/
│   │   ├── admin/
│   │   │   ├── dashboard_controller.rb
│   │   │   ├── stores_controller.rb
│   │   │   └── users_controller.rb
│   │   ├── application_controller.rb
│   │   ├── ratings_controller.rb
│   │   ├── sessions_controller.rb
│   │   ├── stores_controller.rb
│   │   └── users_controller.rb
│   ├── models/
│   │   ├── rating.rb
│   │   ├── store.rb
│   │   └── user.rb
│   └── views/
│       ├── sessions/
│       └── users/
├── config/
│   └── routes.rb
├── db/
│   ├── migrate/
│   └── seeds.rb
└── Gemfile
```

## Key Features Implementation

### Authentication & Authorization
- Custom authentication system using bcrypt
- Role-based access control with before_action filters
- Session management for user login/logout

### Data Validation
- Comprehensive validations on all models
- Custom validation methods for business rules
- Error handling and user feedback

### Search & Filtering
- Store search by name and address
- User filtering by multiple criteria
- Sorting functionality on important fields

### Rating System
- One rating per user per store constraint
- Rating modification capability
- Average rating calculations
- Rating statistics and analytics

## Security Features
- Password encryption using bcrypt
- CSRF protection
- Role-based access control
- Input validation and sanitization

## Database Relationships
- User has_one Store (for store owners)
- User has_many Ratings
- Store belongs_to User
- Store has_many Ratings
- Rating belongs_to User and Store

## Future Enhancements
- Email notifications
- Advanced analytics dashboard
- Image upload for stores
- Review comments along with ratings
- API endpoints for mobile applications

## Development Notes
- Follow Rails conventions and best practices
- Comprehensive error handling
- Responsive design considerations
- Scalable architecture for future enhancements

