-- Airbnb Database Implementation
-- This script contains SQL statements to create the database, document enumerations, and create tables.
-- Purpose: To implement a database management system for an Airbnb-like application.
-- ER-Model: The database is designed to manage guests, hosts, properties, bookings, payments, and related entities.

DROP DATABASE IF EXISTS airbnbsystem;
CREATE DATABASE airbnbSystem;
USE airbnbSystem;

-- List of ENUM values used in the database:
-- Gender ENUM options: 'Female', 'Male'
-- ReferralInfo ENUM options: 'Referred', 'Not-Referred'
-- PaymentStatus ENUM options: 'Successful', 'Pending', 'Declined'
-- PaymentMethod ENUM options: 'Bank Transfer', 'Credit Card', 'Debit Card', 'PayPal'
-- Role ENUM options: 'Host', 'Guest'

-- Table: Guest
-- Purpose: Stores information about guests who book properties
CREATE TABLE Guest (
    GuestID INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each guest
    Name VARCHAR(255) NOT NULL,   -- Guest's full name
    Email VARCHAR(255) UNIQUE NOT NULL,   -- Guest's email address (must be unique)
    Phone VARCHAR(20),   -- Guest's phone number
    Age INT,   -- Guest's age
    Gender ENUM('Female','Male'),   -- Guest's gender
    LoyaltyPoints INT DEFAULT 0,   -- Guest's loyalty points (default is 0)
    ReferralInfo ENUM('Referred','Not-Referred')   -- Indicates if the guest was referred
);

-- Table: Host
-- Purpose: Stores details about hosts who list properties
CREATE TABLE Host (
    HostID INT AUTO_INCREMENT PRIMARY KEY,   -- Unique identifier for each host
    Name VARCHAR(255) NOT NULL,   -- Host's full name
    Email VARCHAR(255) UNIQUE NOT NULL,   -- Host's email address (must be unique)
    Gender ENUM('Female','Male'),   -- Host's gender
    Phone VARCHAR(20),   -- Host's phone number
    HostProfile TEXT,  -- Host's profile description
    PropertiesListed TEXT   -- Information about properties listed by the host
);


-- Table: Location
-- Purpose: Store location details for properties
CREATE TABLE Location (
    LocationID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each location
    City VARCHAR(100) NOT NULL,  -- City where the property is located
    State VARCHAR(100),  -- State where the property is located
    Country VARCHAR(100) NOT NULL  -- Country where the property is located
);

-- Table: Property
-- Purpose: Store details of properties listed by hosts
CREATE TABLE Property (
    PropertyID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each property
    HostID INT,   -- References the Host who owns the property
    LocationID INT,   -- References the Location of the property
    Price DECIMAL(10,2) NOT NULL,  -- Price per night or booking for the property
    Type VARCHAR(100),   -- Type of the property (e.g., apartment, house, etc.)
    Amenities TEXT,   -- List of amenities available at the property
    Rules TEXT,   -- Rules of the property (e.g., no smoking, no pets)
    Availability BOOLEAN DEFAULT TRUE,   -- Availability status of the property (TRUE = available, FALSE = not available)
    FOREIGN KEY (HostID) REFERENCES Host(HostID),  -- Ensures Property is linked to a Host
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID)  -- Ensures Property is linked to a Location
);


-- Table: Booking
-- Purpose: Store details of bookings made by guests
CREATE TABLE Booking (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each booking
    GuestID INT,  -- References the Guest who made the booking
    PropertyID INT,  -- References the Property being booked
    CheckInDate DATE NOT NULL,  -- Check-in date for the booking
    CheckOutDate DATE NOT NULL,  -- Check-out date for the booking
    PaymentStatus ENUM('Successful','Pending','Declined'),  -- Payment status of the booking
    BookingDate DATE NOT NULL,  -- Date the booking was made
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),  -- Ensures the Booking is linked to a Guest
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)   -- Ensures the Booking is linked to a Property
);

-- Table: Payment
-- Purpose: Store details of payments for bookings
CREATE TABLE Payment (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each payment
    BookingID INT,  -- References the Booking for which the payment was made
    Amount DECIMAL(10,2) NOT NULL,  -- Payment amount for the booking
    PaymentDate DATE NOT NULL,  -- Date the payment was made
    PaymentMethod ENUM('Bank Transfer','Credit Card','Debit Card', 'PayPal'),  -- Payment method used
    FOREIGN KEY (BookingID) REFERENCES Booking(BookingID)  -- Ensures the Payment is linked to a Booking
);

-- Table: Review
-- Purpose: Store reviews provided by guests for properties
CREATE TABLE Review (
    ReviewID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each review
    GuestID INT,  -- References the Guest who provided the review
    PropertyID INT,  -- References the Property being reviewed
    Rating INT CHECK (Rating BETWEEN 1 AND 5),  -- Rating for the property (between 1 and 5)
    Comment TEXT,  -- Guest's comments for the property
    ReviewDate DATE NOT NULL,  -- Date the review was provided
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),  -- Ensures the Review is linked to a Guest
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)  -- Ensures the Review is linked to a Property
);

-- Table: Referral
-- Purpose: Track referrals made by guests
CREATE TABLE Referral (
    ReferralID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each referral
    ReferrerID INT,  -- References the Guest who made the referral
    ReferredUserID INT,  -- References the Guest who was referred
    ReferralDate DATE,  -- Date the referral was made
    RewardEarned DECIMAL(10,2),  -- Reward earned by the Referrer for the referral
    FOREIGN KEY (ReferrerID) REFERENCES Guest(GuestID),  -- Ensures the referral is linked to a Referrer
    FOREIGN KEY (ReferredUserID) REFERENCES Guest(GuestID)  -- Ensures the referral is linked to a Referred User
);

-- Table: Message
-- Purpose: Store messages exchanged between users
CREATE TABLE Message (
    MessageID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each message
    SenderID INT,  -- References the Guest who sent the message
    ReceiverID INT,  -- References the Guest who receives the message
    Content TEXT NOT NULL,  -- Content of the message
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,  -- Timestamp when the message was sent
    FOREIGN KEY (SenderID) REFERENCES Guest(GuestID),  -- Ensures the message is linked to a Sender
    FOREIGN KEY (ReceiverID) REFERENCES Guest(GuestID)  -- Ensures the message is linked to a Receiver
);

-- Table: Promotion
-- Purpose: Manage promotions offered by hosts
CREATE TABLE Promotion (
    PromoID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each promotion
    HostID INT,  -- References the Host offering the promotion
    PropertyID INT,  -- References the Property to which the promotion applies
    DiscountRate DECIMAL(5,2),  -- Discount rate offered for the promotion
    StartDate DATE NOT NULL,  -- Start date of the promotion
    EndDate DATE NOT NULL,  -- End date of the promotion
    FOREIGN KEY (HostID) REFERENCES Host(HostID),  -- Ensures the promotion is linked to a Host
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)  -- Ensures the promotion is linked to a Property
);


-- Table: MaintenanceRequest
-- Purpose: Track maintenance requests for properties
CREATE TABLE MaintenanceRequest (
    RequestID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each maintenance request
    PropertyID INT,  -- References the Property for which maintenance is requested
    RequestDate DATE NOT NULL,  -- Date the maintenance request was made
    Status VARCHAR(50),  -- Current status of the maintenance request (e.g., Pending, Completed)
    Description TEXT,  -- Description of the maintenance issue
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)  -- Ensures the request is linked to a Property
);

-- Table: Amenity
-- Purpose: Manage amenities available in properties
CREATE TABLE Amenity (
    AmenityID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each amenity
    Description TEXT NOT NULL  -- Description of the amenity (e.g., Swimming Pool, WiFi)
);

-- Table: Type
-- Purpose: Define types of properties
CREATE TABLE Type (
    TypeID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each property type
    Description TEXT NOT NULL  -- Description of the property type (e.g., Apartment, House, Villa)
);

-- Table: Calendar
-- Purpose: Manage property availability dates
CREATE TABLE Calendar (
    CalendarID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each calendar entry
    PropertyID INT,  -- References the Property to which the availability relates
    Date DATE NOT NULL,  -- Date for which availability is tracked
    Availability BOOLEAN DEFAULT TRUE,  -- Indicates whether the property is available (TRUE) or not (FALSE)
    FOREIGN KEY (PropertyID) REFERENCES Property(PropertyID)  -- Ensures the calendar entry is linked to a Property
);

-- Table: LoyaltyProgram
-- Purpose: Track loyalty programs for guests
CREATE TABLE LoyaltyProgram (
    ProgramID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for the loyalty program
    GuestID INT,  -- References the Guest participating in the loyalty program
    PointsEarned INT DEFAULT 0,  -- Points earned by the guest
    PointsRedeemed INT DEFAULT 0,  -- Points redeemed by the guest
    ExpiryDate DATE,  -- Expiry date for the loyalty program
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID)  -- Ensures the loyalty program is linked to a Guest
);

-- Table: Rules
-- Purpose: Define rules for properties
CREATE TABLE Rules (
    RuleID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each rule
    Description TEXT NOT NULL  -- Description of the rule (e.g., No smoking, No pets)
);

-- Table: Transaction
-- Purpose: Store transaction details
CREATE TABLE Transaction (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each transaction
    PaymentID INT,  -- References the Payment related to the transaction
    Amount DECIMAL(10,2) NOT NULL,  -- Amount involved in the transaction
    Timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,  -- Timestamp of when the transaction occurred
    FOREIGN KEY (PaymentID) REFERENCES Payment(PaymentID)  -- Ensures the transaction is linked to a Payment
);

-- Table: ReviewFlag
-- Purpose: Track flagged reviews for moderation
CREATE TABLE ReviewFlag (
    FlagID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each review flag
    ReviewID INT,  -- References the Review being flagged
    FlaggedBy INT,  -- References the Guest who flagged the review
    Reason TEXT,  -- Reason for flagging the review (e.g., inappropriate content)
    FOREIGN KEY (ReviewID) REFERENCES Review(ReviewID),  -- Ensures the flag is linked to a Review
    FOREIGN KEY (FlaggedBy) REFERENCES Guest(GuestID)  -- Ensures the flagger is linked to a Guest
);

-- Table: User
-- Purpose: Manage users and their roles
CREATE TABLE User (
    UserID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each user
    Name VARCHAR(255) NOT NULL,  -- Name of the user
    Email VARCHAR(255) UNIQUE NOT NULL,  -- Email of the user
    GuestID INT,  -- References the Guest account associated with the user (if any)
    HostID INT,  -- References the Host account associated with the user (if any)
    Role ENUM('Host', 'Guest'),  -- Role of the user (either Host or Guest)
    FOREIGN KEY (GuestID) REFERENCES Guest(GuestID),  -- Links the user to a Guest (if role is Guest)
    FOREIGN KEY (HostID) REFERENCES Host(HostID)  -- Links the user to a Host (if role is Host)
);

-- Table: ReferralReward
-- Purpose: Manage rewards for successful referrals
CREATE TABLE ReferralReward (
    RewardID INT AUTO_INCREMENT PRIMARY KEY,  -- Unique identifier for each referral reward
    ReferrerID INT,  -- References the Guest who made the referral
    RewardDescription TEXT NOT NULL,  -- Description of the reward (e.g., Discount, Points)
    RedemptionStatus VARCHAR(50),  -- Status of the reward redemption (e.g., Pending, Redeemed)
    FOREIGN KEY (ReferrerID) REFERENCES Guest(GuestID)  -- Ensures the reward is linked to the Referrer
);
