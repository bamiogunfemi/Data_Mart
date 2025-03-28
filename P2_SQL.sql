-- Airbnb Database Implementation
-- This script contains SQL statements to create tables, define relationships, and populate them with sample data.
-- Author: [Your Name]
-- Date: [Insert Date]
-- Purpose: To implement a database management system for an Airbnb-like application.
-- ER-Model: The database is designed to manage guests, hosts, properties, bookings, payments, and related entities.


DROP DATABASE airbnbsystem;
CREATE DATABASE airbnbSystem;
USE airbnbSystem;

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




-- Insert sample data into Guest
INSERT INTO Guest (Name, Email, Phone, Age, Gender, LoyaltyPoints, ReferralInfo) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-1234', 32, 'Female', 150, 'Referred'),
('Bob Smith', 'bob.smith@example.com', '555-5678', 22,'Male', 200, 'Referred'),
('Carla Williams', 'carla.williams@example.com', '555-2345', 19,'Female', 120, 'Not-Referred'),
('David Brown', 'david.brown@example.com', '555-6789', 26, 'Male', 300, 'Not-Referred'),
('Eve Davis', 'eve.davis@example.com', '555-3456', 44, 'Male', 250, 'Not-Referred'),
('Frank Miller', 'frank.miller@example.com', '555-4567', 33, 'Male', 80, 'Not-Referred'),
('Grace Wilson', 'grace.wilson@example.com', '555-7890', 50, 'Female', 110, 'Referred'),
('Henry Moore', 'henry.moore@example.com', '555-1122', 23,  'Male', 400, 'Not-Referred'),
('Isla Taylor', 'isla.taylor@example.com', '555-3344',44,'Female',  90, 'Referred'),
('Jack White', 'jack.white@example.com', '555-5566',55, 'Male',  220, 'Referred'),
('Kara Lee', 'kara.lee@example.com', '555-6677',21, 'Male',  130, 'Referred'),
('Leo Harris', 'leo.harris@example.com', '555-7788',25, 'Female', 250, 'Referred'),
('Megan Clark', 'megan.clark@example.com', '555-8899', 22, 'Female', 170, 'Referred'),
('Nina Scott', 'nina.scott@example.com', '555-9900', 20,'Female', 60,'Not-Referred'),
('Oscar Adams', 'oscar.adams@example.com', '555-1230',43,  'Male', 180, 'Referred'),
('Paige Taylor', 'paige.taylor@example.com', '555-4321', 28,  'Male', 140, 'Not-Referred'),
('Quinn Hall', 'quinn.hall@example.com', '555-5432', 48,  'Male', 210, 'Not-Referred'),
('Rachel Green', 'rachel.green@example.com', '555-6543', 53, 'Male', 250, 'Referred'),
('Sam Lewis', 'sam.lewis@example.com', '555-7654',33,  'Male', 190, 'Referred'),
('Tina Young', 'tina.young@example.com', '555-8765', 43,'Female', 130 ,'Not-Referred'),
('Ursula Wright', 'ursula.wright@example.com', '555-9876',27, 'Female', 320, 'Referred'),
('Victor Perez', 'victor.perez@example.com', '555-4325', 49,  'Male', 100, 'Referred'),
('Wendy King', 'wendy.king@example.com', '555-5431', 37,  'Male', 160, 'Referred'),
('Xander Martin', 'xander.martin@example.com', '555-6542', 54,  'Male',  140, 'Referred'),
('Yasmine Hall', 'yasmine.hall@example.com', '555-7653', 33, 'Female',200, 'Referred'),
('Zane Nelson', 'zane.nelson@example.com', '555-8764', 45, 'Male',  210, 'Referred');

-- Insert sample data into Host
INSERT INTO Host (Name, Email, Gender, Phone, HostProfile, PropertiesListed) VALUES
('Seun Akinbiyi', 'seunakin344@example.com',  'Male', '555331010', 'Experienced host specializing in vacation rentals with a passion for hospitality.', 'Beach House, Mountain Cabin'),
('Brian Adams', 'brian.adams@example.com',  'Male','555332020', 'Professional property manager with a portfolio of luxury rentals.', 'City Apartment, Suburban Home'),
('Daniel Jones', 'danjones56@example.com',  'Male', '7812788030', 'Dedicated to providing a seamless experience for both guests and property owners.', 'Coastal Villa, Forest Retreat'),
('Danielle Willaims', 'daniellewills22@example.com', 'Female','555-4040', 'Friendly host who enjoys meeting new people and making them feel at home.', 'Urban Loft, Ski Resort'),
('Eleanor White', 'eleanor.white@example.com','Female', '555-5050', 'Offers a variety of charming homes for travelers looking for unique stays.', 'Country Inn, Lakefront Cabin'),
('Frank Miller', 'frank.miller@example.com',  'Male', '555-6060', 'Specializing in high-end properties and providing top-notch amenities.', 'Luxury Villa, Downtown Condo'),
('Grace Wilson', 'grace.wilson@example.com','Female', '555-7070', 'Host with a focus on eco-friendly and sustainable properties.', 'Eco House, Mountain Retreat'),
('Henry Harris', 'henry.harris@example.com', 'Male',  '555-8080', 'With a passion for adventure, Henry hosts unique properties in remote locations.', 'Desert Lodge, Treehouse'),
('Akindele Jedidiah ', 'iakinjedd34@example.com',  'Male', '555-9090', 'Hosts cozy, affordable rentals for people looking to escape to nature.', 'Cottage, Seaside Apartment'),
('Jack Smith', 'jack.smith@example.com', 'Male',  '555-1001', 'Experienced in hosting a variety of properties, from city apartments to rural homes.', 'Farmhouse, Urban Loft'),
('Daniel Davis', 'dan33davis@example.com', 'Male', '555-2002', 'Known for great customer service and maintaining well-kept properties.', 'Penthouse, Suburban House'),
('Mary Johnson', 'mary.johnson@example.com','Female', '555-3003', 'A long-time host offering a variety of family-friendly properties.', 'Beachfront Cottage, Cabin in the Woods'),
('Emmanuel John', 'emmajohn@example.com', 'Male', '555-4004', 'A host dedicated to ensuring all guests feel at home with exceptional amenities.', 'Cozy Studio, Lakehouse'),
('Sarah White', 'sarawhite@example.com', 'Female','555-5005', 'Hosts exclusive and luxurious villas, focusing on premium experiences for guests.', 'Oceanfront Villa, Private Island'),
('Olivia Brown', 'olivia.brown@example.com', 'Female', '555-6006', 'Welcoming host with a wide range of properties in vibrant urban centers.', 'City Penthouse, Modern Apartment'),
('linda Adams', 'linda33adams@example.com','Female', '555-7007', 'Offers a diverse set of properties, with a focus on affordability and accessibility.', 'Mountain Cabin, Cottage by the Lake'),
('Quincy Miller', 'quincy.miller@example.com', 'Female','555-8008', 'Experienced in short-term rentals with a focus on unique homes and excellent guest service.', 'Ski Chalet, Coastal Retreat'),
('Samuel Clark', 'samuelclark@example.com', 'Male', '555-9009', 'Hosts beautiful homes that blend modern luxury with natural surroundings.', 'Luxury House, Forest Cabin'),
('Ella Harris', 'Ellaharris@example.com','Female', '555-1011', 'With years of experience, Sam provides a seamless and personalized guest experience.', 'Mountain Lodge, City Loft'),
('Tina Moore', 'tina.moore@example.com','Female', '555-2022', 'A passionate host who loves to help guests discover new locations.', 'Seaside Cottage, Cabin Retreat'),
('Ursula Green', 'ursula.green@example.com', 'Male', '555-3033', 'Dedicated to offering eco-friendly and sustainable vacation homes.', 'Eco Villa, Lakeside Cabin'),
('Victor Lee', 'victor.lee@example.com','Male', '555-4044', 'Host with a keen eye for detail, offering only the finest luxury properties.', 'Luxury Penthouse, Beachfront House'),
('Wendy King', 'wendy.king@example.com',  'Female','555-5055', 'Well-versed in hosting both short and long-term rentals with a focus on comfort.', 'Downtown Studio, Suburban Home'),
('Xander Harris', 'xander.harris@example.com',  'Male','555-6066', 'A seasoned host offering a variety of rental options for guests of all types.', 'City Loft, Urban Penthouse'),
('Yasmine White', 'yasmine.white@example.com', 'Female','555-7077', 'Hosts properties that are as stylish as they are comfortable.', 'Luxury Cottage, City Loft'),
('Zane Scott', 'zane.scott@example.com',  'Male','555-8088', 'Known for providing unique stays with a personal touch and exceptional service.', 'Modern Villa, Coastal Apartment');


-- Insert sample data into Location
INSERT INTO Location (City, State, Country) VALUES
('New York', 'New York', 'USA'),
('Los Angeles', 'California', 'USA'),
('London', '', 'UK'),
('Paris', '', 'France'),
('Tokyo', '', 'Japan'),
('Sydney', 'New South Wales', 'Australia'),
('Berlin', '', 'Germany'),
('Rome', '', 'Italy'),
('Dubai', '', 'UAE'),
('Barcelona', '', 'Spain'),
('Toronto', 'Ontario', 'Canada'),
('Miami', 'Florida', 'USA'),
('San Francisco', 'California', 'USA'),
('Vancouver', 'British Columbia', 'Canada'),
('Cairo', '', 'Egypt'),
('Lagos', '', 'Nigeria'),
('Bangkok', '', 'Thailand'),
('Singapore', '', 'Singapore'),
('Mexico City', '', 'Mexico'),
('Beijing', '', 'China'),
('Buenos Aires', '', 'Argentina'),
('Moscow', '', 'Russia'),
('Amsterdam', '', 'Netherlands'),
('Lisbon', '', 'Portugal'),
('Cape Town', '', 'South Africa');


-- Insert sample data into Property
INSERT INTO Property (HostID, LocationID, Price, Type, Amenities, Rules, Availability) VALUES
(1, 1, 350.00, 'Beach House', 'WiFi, Pool, Ocean View', 'No parties, No smoking', TRUE),
(1, 2, 250.00, 'Mountain Cabin', 'WiFi, Fireplace, Hot Tub', 'No pets, No loud music', TRUE),
(2, 3, 400.00, 'City Apartment', 'WiFi, Gym, Parking', 'No pets, No parties', TRUE),
(2, 4, 300.00, 'Suburban Home', 'WiFi, Garden, BBQ', 'No smoking', TRUE),
(3, 5, 500.00, 'Coastal Villa', 'WiFi, Pool, Ocean View', 'No pets', TRUE),
(3, 6, 200.00, 'Forest Retreat', 'WiFi, Firepit, Hiking Trails', 'No smoking', TRUE),
(4, 7, 150.00, 'Urban Loft', 'WiFi, Elevator, Gym', 'No loud music, No smoking', TRUE),
(4, 8, 300.00, 'Ski Resort', 'WiFi, Ski-In, Ski-Out', 'No parties', TRUE),
(5, 9, 180.00, 'Country Inn', 'WiFi, Free Breakfast, Parking', 'No pets', TRUE),
(5, 10, 250.00, 'Lakefront Cabin', 'WiFi, Kayaks, BBQ', 'No smoking', TRUE),
(6, 11, 800.00, 'Luxury Villa', 'WiFi, Pool, Spa', 'No parties, No loud music', TRUE),
(6, 12, 450.00, 'Downtown Condo', 'WiFi, Gym, Concierge', 'No pets, No smoking', TRUE),
(7, 13, 220.00, 'Eco House', 'WiFi, Solar Energy, Garden', 'No smoking', TRUE),
(7, 14, 320.00, 'Mountain Retreat', 'WiFi, Hot Tub, Fireplace', 'No pets', TRUE),
(8, 15, 180.00, 'Desert Lodge', 'WiFi, Pool, Desert Tours', 'No smoking', TRUE),
(8, 16, 250.00, 'Treehouse', 'WiFi, Secluded, Deck', 'No pets', TRUE),
(9, 17, 200.00, 'Seaside Apartment', 'WiFi, Beach Access, Balcony', 'No parties', TRUE),
(9, 18, 150.00, 'Cottage', 'WiFi, Garden, Parking', 'No smoking', TRUE),
(10, 19, 100.00, 'Farmhouse', 'WiFi, Firepit, Parking', 'No pets', TRUE),
(10, 20, 300.00, 'Urban Loft', 'WiFi, Gym, Elevator', 'No smoking', TRUE),
(11, 21, 350.00, 'Penthouse', 'WiFi, Rooftop Pool, Concierge', 'No parties, No pets', TRUE),
(12, 22, 270.00, 'Beach House', 'WiFi, Ocean View, Balcony', 'No pets, No smoking', TRUE),
(13, 23, 220.00, 'Studio Apartment', 'WiFi, Parking', 'No parties, No smoking', TRUE),
(14, 24, 280.00, 'Mountain Chalet', 'WiFi, Hot Tub, Fireplace', 'No pets', TRUE),
(15, 25, 350.00, 'Luxury Apartment', 'WiFi, Gym, Pool', 'No smoking, No parties', TRUE);


-- Insert sample data into Booking
INSERT INTO Booking (GuestID, PropertyID, CheckInDate, CheckOutDate, PaymentStatus, BookingDate) VALUES
(16, 9, '2025-02-10', '2025-02-14', 'Successful', '2025-01-25'),
(1, 7, '2025-02-12', '2025-02-16', 'Pending', '2025-01-26'),
(19, 6, '2025-02-15', '2025-02-20', 'Successful', '2025-01-27'),
(4, 1, '2025-02-18', '2025-02-22', 'Declined', '2025-01-28'),
(21, 13, '2025-02-22', '2025-02-26', 'Successful', '2025-01-29'),
(11, 5, '2025-02-24', '2025-02-28', 'Pending', '2025-01-30'),
(2, 19, '2025-03-01', '2025-03-05', 'Successful', '2025-01-31'),
(6, 2, '2025-03-03', '2025-03-07', 'Declined', '2025-02-01'),
(3, 12, '2025-03-07', '2025-03-12', 'Successful', '2025-02-02'),
(12, 8, '2025-03-10', '2025-03-15', 'Pending', '2025-02-03'),
(14, 4, '2025-03-12', '2025-03-16', 'Declined', '2025-02-04'),
(17, 3, '2025-03-15', '2025-03-20', 'Successful', '2025-02-05'),
(8, 16, '2025-03-18', '2025-03-22', 'Pending', '2025-02-06'),
(18, 10, '2025-03-20', '2025-03-25', 'Successful', '2025-02-07'),
(5, 14, '2025-03-22', '2025-03-26', 'Declined', '2025-02-08'),
(13, 15, '2025-03-25', '2025-03-30', 'Successful', '2025-02-09'),
(20, 17, '2025-03-28', '2025-04-01', 'Pending', '2025-02-10'),
(7, 20, '2025-04-01', '2025-04-05', 'Successful', '2025-02-11'),
(15, 11, '2025-04-03', '2025-04-07', 'Declined', '2025-02-12'),
(22, 18, '2025-04-05', '2025-04-09', 'Pending', '2025-02-13'),
(25, 9, '2025-04-08', '2025-04-12', 'Successful', '2025-02-14'),
(10, 22, '2025-04-10', '2025-04-14', 'Declined', '2025-02-15'),
(9, 21, '2025-04-12', '2025-04-16', 'Pending', '2025-02-16'),
(23, 23, '2025-04-15', '2025-04-19', 'Successful', '2025-02-17'),
(24, 24, '2025-04-18', '2025-04-22', 'Declined', '2025-02-18');

-- Insert sample data into Payment
INSERT INTO Payment (BookingID, Amount, PaymentDate, PaymentMethod) VALUES
(1, 500.00, '2025-01-25', 'Credit Card'),
(2, 720.00, '2025-01-26', 'PayPal'),
(3, 600.00, '2025-01-20', 'Debit Card'),
(4, 480.00, '2025-01-22', 'Credit Card'),
(5, 1100.00, '2025-01-24', 'PayPal'),
(6, 950.00, '2025-01-23', 'Credit Card'),
(7, 880.00, '2025-01-30', 'Debit Card'),
(8, 1200.00, '2025-01-21', 'Credit Card'),
(9, 1350.00, '2025-01-28', 'PayPal'),
(10, 800.00, '2025-01-27', 'Debit Card'),
(11, 1100.00, '2025-01-18', 'Credit Card'),
(12, 1500.00, '2025-01-29', 'PayPal'),
(13, 1000.00, '2025-02-01', 'Credit Card'),
(14, 1100.00, '2025-01-15', 'Debit Card'),
(15, 950.00, '2025-02-05', 'PayPal'),
(16, 850.00, '2025-01-10', 'Credit Card'),
(17, 880.00, '2025-02-03', 'Debit Card'),
(18, 1100.00, '2025-01-12', 'Credit Card'),
(19, 650.00, '2025-01-18', 'PayPal'),
(20, 880.00, '2025-01-19', 'Debit Card'),
(21, 1150.00, '2025-02-02', 'Credit Card'),
(22, 1100.00, '2025-01-26', 'PayPal'),
(23, 1300.00, '2025-01-30', 'Debit Card'),
(24, 1000.00, '2025-02-04', 'PayPal'),
(25, 960.00, '2025-01-24', 'Credit Card');


-- Insert sample data into Review
INSERT INTO Review (GuestID, PropertyID, Rating, Comment, ReviewDate) VALUES
(1, 3, 5, 'Wonderful cabin! The ski-in/ski-out access was perfect for our trip. Would definitely stay again.', '2025-02-15'),
(2, 5, 4, 'Great villa with a beautiful view. Some minor issues with the heating system, but overall a pleasant stay.', '2025-03-02'),
(3, 9, 5, 'Amazing location and well-equipped apartment. Loved the rooftop terrace and the modern amenities.', '2025-04-18'),
(4, 2, 3, 'The apartment was fine, but the elevator was out of order for part of our stay, which was inconvenient.', '2025-05-03'),
(5, 8, 5, 'Perfect getaway! The cottage was cozy and had everything we needed. Highly recommend for a peaceful retreat.', '2025-06-12'),
(6, 7, 4, 'Nice house, but the hot tub could have been cleaner. Overall, it was a great experience.', '2025-02-17'),
(7, 4, 2, 'The property was fine, but there was a lot of noise from construction next door, which affected our stay.', '2025-03-15'),
(8, 6, 5, 'Absolutely loved the studio! It was very comfortable and close to everything I needed. Will book again next time I’m in town.', '2025-04-07'),
(9, 10, 5, 'Had a wonderful time in this penthouse! The view was breathtaking, and the amenities were top-notch.', '2025-02-20'),
(10, 11, 4, 'The mansion was beautiful, but I wish there had been more variety in the entertainment options.', '2025-03-08'),
(11, 14, 5, 'A truly luxurious stay. Everything was perfect, and the private pool made our vacation unforgettable.', '2025-07-03'),
(12, 12, 5, 'The villa was stunning! It had all the comforts we needed, and the wine tasting room was an amazing bonus.', '2025-06-18'),
(13, 13, 3, 'Nice property, but the property manager was unresponsive to some of our requests. Could have been better.', '2025-05-13'),
(14, 1, 5, 'The beach house was fantastic! It was a perfect vacation spot for our family, and we loved the pool and parking convenience.', '2025-02-08'),
(15, 4, 3, 'The house was nice, but there was some miscommunication about the check-in process. It could be improved.', '2025-04-28'),
(16, 2, 5, 'Amazing apartment! Everything was clean and modern. Definitely worth the price, and I’ll stay again next time.', '2025-07-12'),
(17, 6, 4, 'Had a good time at the apartment, but the WiFi was a bit spotty. Still a great place overall.', '2025-05-02'),
(18, 7, 5, 'Beautiful location and cozy house! We loved the hiking trails nearby, and the fireplace was perfect for cold evenings.', '2025-03-12'),
(19, 8, 5, 'Great stay! The cottage was everything we hoped for. We had a wonderful time by the fireplace and hiking around the area.', '2025-02-25'),
(20, 5, 4, 'Nice villa with all the amenities we needed, but we had a small issue with the BBQ not working properly.', '2025-04-12'),
(21, 11, 5, 'The penthouse was perfect for our vacation! The city view at night was breathtaking, and the Jacuzzi was amazing.', '2025-06-03'),
(22, 9, 4, 'Nice property and great location. However, the check-in process took longer than expected, which was a bit inconvenient.', '2025-02-23'),
(23, 10, 3, 'The condo was fine, but it wasn’t as clean as expected. There were a few maintenance issues that needed attention.', '2025-03-18'),
(24, 3, 5, 'A fantastic place to stay! The location was perfect for skiing, and the house was well-equipped with everything we needed.', '2025-07-25'),
(25, 12, 5, 'Absolutely loved the beach cottage! The ocean view was stunning, and the BBQ made for a great evening with friends.', '2025-04-27');


-- Insert sample data into Referral
INSERT INTO Referral (ReferrerID, ReferredUserID, ReferralDate, RewardEarned) VALUES
(1, 2, '2025-01-15', 20.00),
(3, 4, '2025-01-20', 25.00),
(5, 6, '2025-02-02', 30.00),
(2, 7, '2025-01-28', 15.00),
(4, 8, '2025-02-05', 10.00),
(6, 9, '2025-01-22', 20.00),
(7, 10, '2025-02-03', 35.00),
(8, 11, '2025-02-10', 25.00),
(9, 12, '2025-01-25', 40.00),
(10, 13, '2025-01-30', 15.00),
(11, 14, '2025-02-01', 20.00),
(12, 15, '2025-02-07', 50.00),
(13, 16, '2025-01-18', 30.00),
(14, 17, '2025-02-04', 25.00),
(15, 18, '2025-02-08', 15.00),
(16, 19, '2025-02-12', 10.00),
(17, 20, '2025-01-17', 30.00),
(18, 21, '2025-01-24', 35.00),
(19, 22, '2025-02-06', 20.00),
(20, 23, '2025-01-29', 40.00),
(21, 24, '2025-02-13', 25.00),
(22, 25, '2025-01-12', 15.00),
(23, 1, '2025-02-02', 50.00),
(24, 5, '2025-02-11', 10.00),
(25, 6, '2025-02-04', 30.00);

-- Insert sample data into Message
INSERT INTO Message (SenderID, ReceiverID, Content) VALUES
(1, 2, 'Hi, I just booked a property. Can you provide more details on the amenities?'),
(2, 3, 'Your reservation has been confirmed. Please check your email for further details.'),
(3, 4, 'Is the property available for an extra night? I am interested in extending my stay.'),
(4, 5, 'I had a great time staying at your property. Thanks for the hospitality!'),
(5, 6, 'Can you send me the check-in instructions for my upcoming stay?'),
(6, 7, 'I noticed a small issue with the bathroom plumbing. Could you send someone to fix it?'),
(7, 8, 'Thanks for your review. Let me know if you need any assistance in the future!'),
(8, 9, 'The check-out time is 11 AM, please ensure to leave by then.'),
(9, 10, 'I’m having trouble accessing the Wi-Fi. Can you help me out?'),
(10, 11, 'Would it be possible to reschedule the booking to next month?'),
(11, 12, 'The property was just as advertised. I loved the view!'),
(12, 13, 'Can you confirm the availability of the property for the weekend of March 15th?'),
(13, 14, 'Thank you for your prompt responses. I look forward to staying at your place.'),
(14, 15, 'The property was exactly what I was looking for! Highly recommend it.'),
(15, 16, 'I noticed some noise from nearby construction. Can this be addressed?'),
(16, 17, 'Can you provide me with a list of nearby restaurants and cafes?'),
(17, 18, 'I’m interested in booking the property for a weekend getaway. Can you confirm availability?'),
(18, 19, 'The place was clean and well-maintained. Thank you for making our stay enjoyable!'),
(19, 20, 'Please let me know if there are any additional charges for the late check-out request.'),
(20, 21, 'I loved the decor of your property! It made my stay extra special.'),
(21, 22, 'Could you send me the address of the property? I’m having trouble finding it on the map.'),
(22, 23, 'Thanks for letting me extend my stay. I’ll definitely be back in the future!'),
(23, 24, 'I had a fantastic experience. Would love to return sometime soon!'),
(24, 25, 'Please let me know the process for canceling the booking.'),
(25, 1, 'I left a positive review for your property. I hope it helps!');


INSERT INTO Promotion (HostID, PropertyID, DiscountRate, StartDate, EndDate) VALUES
(1, 1, 15.00, '2025-01-01', '2025-01-31'),
(2, 2, 10.00, '2025-01-15', '2025-02-15'),
(3, 3, 20.00, '2025-02-01', '2025-02-28'),
(4, 4, 5.00, '2025-02-10', '2025-02-20'),
(5, 5, 30.00, '2025-03-01', '2025-03-31'),
(6, 6, 25.00, '2025-03-10', '2025-03-20'),
(7, 7, 18.00, '2025-04-01', '2025-04-30'),
(8, 8, 22.50, '2025-04-15', '2025-05-15'),
(9, 9, 12.00, '2025-05-01', '2025-05-31'),
(10, 10, 15.50, '2025-05-10', '2025-06-10'),
(11, 11, 7.00, '2025-06-01', '2025-06-30'),
(12, 12, 17.00, '2025-06-15', '2025-07-15'),
(13, 13, 25.00, '2025-07-01', '2025-07-31'),
(14, 14, 10.00, '2025-07-10', '2025-07-20'),
(15, 15, 20.00, '2025-08-01', '2025-08-31'),
(16, 16, 12.00, '2025-08-10', '2025-08-25'),
(17, 17, 30.00, '2025-09-01', '2025-09-30'),
(18, 18, 10.00, '2025-09-10', '2025-09-20'),
(19, 19, 22.00, '2025-10-01', '2025-10-31'),
(20, 20, 18.50, '2025-10-15', '2025-11-15'),
(21, 21, 14.00, '2025-11-01', '2025-11-30'),
(22, 22, 5.00, '2025-11-10', '2025-11-20'),
(23, 23, 12.50, '2025-12-01', '2025-12-31'),
(24, 24, 10.00, '2025-12-10', '2025-12-20'),
(25, 25, 15.00, '2025-12-15', '2025-12-25');



-- Insert sample data into MaintenanceRequest
INSERT INTO MaintenanceRequest (PropertyID, RequestDate, Status, Description) VALUES
(1, '2025-01-10', 'Resolved', 'The heating system was malfunctioning, and the room was too cold.'),
(3, '2025-01-12', 'Pending', 'The hot water supply is inconsistent in the bathroom.'),
(5, '2025-02-01', 'Resolved', 'The dishwasher was not functioning properly. It has been repaired now.'),
(7, '2025-01-25', 'In Progress', 'The refrigerator is making a strange noise.'),
(8, '2025-01-28', 'Pending', 'The air conditioning unit is not cooling the room properly.'),
(2, '2025-02-05', 'Resolved', 'The bathroom sink was clogged and has been fixed.'),
(9, '2025-02-09', 'Pending', 'There is a leak in the kitchen ceiling.'),
(10, '2025-01-30', 'Resolved', 'The Wi-Fi connection was down and has been restored.'),
(4, '2025-02-12', 'In Progress', 'The sliding door is difficult to open and close.'),
(6, '2025-02-15', 'Pending', 'The light in the living room flickers intermittently.'),
(11, '2025-01-18', 'Resolved', 'The microwave stopped working, but it has been repaired.'),
(12, '2025-01-22', 'In Progress', 'The washing machine is not draining water properly.'),
(13, '2025-02-03', 'Pending', 'The front door lock is broken and needs repair.'),
(14, '2025-01-29', 'Resolved', 'The oven was not heating properly. It has been fixed now.'),
(15, '2025-01-25', 'In Progress', 'The window in the bedroom does not close completely.'),
(16, '2025-02-10', 'Resolved', 'The water pressure in the shower was low, but it has been fixed.'),
(17, '2025-01-20', 'Pending', 'The outdoor lights are not working, and need to be checked.'),
(18, '2025-02-07', 'Resolved', 'The faucet in the kitchen was leaking, but it has been repaired.'),
(19, '2025-02-13', 'In Progress', 'There is an issue with the electricity in the guest bedroom.'),
(20, '2025-01-15', 'Resolved', 'The refrigerator was not cooling properly, but it has been fixed.'),
(21, '2025-01-17', 'Pending', 'The curtain rods in the living room are loose and need to be reattached.'),
(22, '2025-02-14', 'In Progress', 'The dishwasher is leaking water onto the floor.'),
(23, '2025-01-19', 'Resolved', 'The doorbell was not working, but it has been repaired.'),
(24, '2025-02-08', 'Pending', 'There is a leak in the bathroom ceiling.'),
(25, '2025-01-11', 'Resolved', 'The air conditioner was malfunctioning, but it has been repaired now.');



-- Insert sample data into Amenity
INSERT INTO Amenity (Description) VALUES
('Free Wi-Fi'),
('Air Conditioning'),
('Heating System'),
('Swimming Pool'),
('Hot Tub'),
('Fitness Center'),
('Washer and Dryer'),
('Free Parking'),
('Pet-Friendly'),
('Fireplace'),
('Fully Equipped Kitchen'),
('Cable TV'),
('Outdoor Patio'),
('Private Balcony'),
('Barbecue Grill'),
('Gated Community'),
('Security Cameras'),
('Elevator'),
('Wheelchair Accessible'),
('Sauna'),
('Smart TV'),
('Free Toiletries'),
('Coffee Maker'),
('Microwave'),
('Dishwasher');

-- Insert sample data into Type
INSERT INTO Type (Description) VALUES
('Apartment'),
('House'),
('Condo'),
('Villa'),
('Cottage'),
('Townhouse'),
('Studio'),
('Loft'),
('Bungalow'),
('Chalet'),
('Penthouse'),
('Farmhouse'),
('Cabin'),
('Beach House'),
('Villa with Pool'),
('Luxury Apartment'),
('Historical Building'),
('Modern Loft'),
('Guest House'),
('Eco-Friendly Home'),
('Skyscraper Apartment'),
('Beachfront Property'),
('Mountain Retreat'),
('City Center Apartment'),
('Lake House'),
('Suburban Home');

-- Insert sample data into Calender
INSERT INTO Calendar (PropertyID, Date, Availability) VALUES
(1, '2025-01-01', TRUE),
(1, '2025-01-02', FALSE),
(1, '2025-01-03', TRUE),
(2, '2025-01-01', TRUE),
(2, '2025-01-02', TRUE),
(2, '2025-01-03', FALSE),
(3, '2025-01-01', TRUE),
(3, '2025-01-02', TRUE),
(3, '2025-01-03', TRUE),
(4, '2025-01-01', FALSE),
(4, '2025-01-02', TRUE),
(4, '2025-01-03', FALSE),
(5, '2025-01-01', TRUE),
(5, '2025-01-02', TRUE),
(5, '2025-01-03', TRUE),
(6, '2025-01-01', FALSE),
(6, '2025-01-02', FALSE),
(6, '2025-01-03', TRUE),
(7, '2025-01-01', TRUE),
(7, '2025-01-02', TRUE),
(7, '2025-01-03', FALSE),
(8, '2025-01-01', FALSE),
(8, '2025-01-02', TRUE),
(8, '2025-01-03', TRUE),
(9, '2025-01-01', TRUE),
(9, '2025-01-02', FALSE);

-- Insert sample data into LoyaltyProgram
INSERT INTO LoyaltyProgram (GuestID, PointsEarned, PointsRedeemed, ExpiryDate) VALUES
(1, 150, 50, '2025-12-31'),
(2, 200, 100, '2025-11-30'),
(3, 50, 20, '2025-10-15'),
(4, 300, 150, '2025-09-01'),
(5, 120, 60, '2025-08-20'),
(6, 500, 200, '2025-07-10'),
(7, 250, 100, '2025-06-30'),
(8, 75, 30, '2025-05-25'),
(9, 400, 200, '2025-04-15'),
(10, 180, 90, '2025-03-01'),
(11, 220, 110, '2025-02-20'),
(12, 90, 40, '2025-01-10'),
(13, 350, 170, '2025-12-01'),
(14, 250, 120, '2025-11-15'),
(15, 140, 70, '2025-10-05'),
(16, 80, 40, '2025-09-10'),
(17, 450, 220, '2025-08-30'),
(18, 200, 90, '2025-07-25'),
(19, 100, 50, '2025-06-05'),
(20, 300, 150, '2025-05-15'),
(21, 350, 150, '2025-04-01'),
(22, 250, 130, '2025-03-10'),
(23, 50, 20, '2025-02-28'),
(24, 120, 60, '2025-01-01'),
(25, 500, 250, '2025-12-25');


-- Insert sample data into Rules
INSERT INTO Rules (Description) VALUES
('No smoking inside the property.'),
('Pets are not allowed unless specified by the host.'),
('No parties or events are permitted without prior approval.'),
('Please respect the check-in and check-out times.'),
('Only registered guests are allowed to stay on the property.'),
('No loud noises after 10 PM.'),
('Guests are responsible for the property’s condition during their stay.'),
('Parking is available for a maximum of two vehicles per booking.'),
('The use of illegal substances on the property is prohibited.'),
('Guests should dispose of trash in the designated bins.'),
('The host must be notified of any damages within 24 hours of check-in.'),
('Swimming pool usage is allowed between 8 AM and 8 PM only.'),
('Guests should not rearrange the furniture without permission.'),
('No additional guests without the host’s consent.'),
('Please turn off lights and appliances when not in use.'),
('Do not engage in disruptive behavior that disturbs the neighbors.'),
('Any electrical equipment brought into the property must be safe and in good condition.'),
('The property should be left in a reasonably clean condition upon check-out.'),
('Barbecue grills must be used in the designated outdoor areas only.'),
('Guests are responsible for securing their personal belongings.'),
('No cooking of strong-smelling foods without prior approval.'),
('The host reserves the right to enter the property for maintenance or emergencies.'),
('All amenities must be used responsibly and as intended.'),
('Guests must report any maintenance issues immediately to the host.');

-- Insert sample data into Transaction
INSERT INTO Transaction (PaymentID, Amount) VALUES
(1, 150.00),
(2, 200.00),
(3, 120.50),
(4, 350.00),
(5, 450.75),
(6, 80.00),
(7, 199.99),
(8, 250.00),
(9, 300.50),
(10, 180.00),
(11, 145.25),
(12, 550.00),
(13, 90.50),
(14, 220.00),
(15, 300.00),
(16, 100.00),
(17, 60.00),
(18, 180.25),
(19, 150.00),
(20, 420.00),
(21, 175.00),
(22, 275.00),
(23, 500.00),
(24, 400.00),
(25, 600.00);

-- Insert sample data into ReviewFlag
INSERT INTO ReviewFlag (ReviewID, FlaggedBy, Reason) VALUES
(1, 2, 'Offensive language used in the comment'),
(2, 3, 'Irrelevant comment about the property'),
(3, 4, 'False information regarding amenities'),
(4, 5, 'Discriminatory comments about other guests'),
(5, 6, 'Comment did not relate to the actual experience'),
(6, 7, 'Use of inappropriate terms'),
(7, 8, 'Review was excessively harsh without cause'),
(8, 9, 'Untrue claims about the property’s condition'),
(9, 10, 'Review was too vague and unhelpful'),
(10, 11, 'Contains personal attacks against the host'),
(11, 12, 'Misleading information about the location'),
(12, 13, 'Unwarranted complaint about noise levels'),
(13, 14, 'Excessive profanity in the review'),
(14, 15, 'Inaccurate review of property amenities'),
(15, 16, 'Hateful speech or bullying in the comment'),
(16, 17, 'Review included irrelevant details'),
(17, 18, 'False accusations about property management'),
(18, 19, 'Aggressive tone and unfair criticism'),
(19, 20, 'Review does not match the guest’s stay'),
(20, 21, 'Comment based on personal vendettas'),
(21, 22, 'Misrepresentation of host’s behavior'),
(22, 23, 'Review used discriminatory language'),
(23, 24, 'Overly negative without constructive feedback'),
(24, 25, 'Comment was off-topic and not helpful'),
(25, 1, 'Review used inappropriate comparisons');


-- Insert sample data into User
INSERT INTO User (Name, Email, GuestID, HostID, Role) VALUES
('John Doe', 'john.doe@example.com', 1, NULL, 'Guest'),
('Jane Smith', 'jane.smith@example.com', 2, NULL, 'Guest'),
('Alice Brown', 'alice.brown@example.com', 3, NULL, 'Guest'),
('Bob White', 'bob.white@example.com', 4, NULL, 'Guest'),
('Charlie Green', 'charlie.green@example.com', 5, NULL, 'Guest'),
('Emily Davis', 'emily.davis@example.com', 6, NULL, 'Guest'),
('Daniel Clark', 'daniel.clark@example.com', 7, NULL, 'Guest'),
('Sophia Miller', 'sophia.miller@example.com', 8, NULL, 'Guest'),
('James Wilson', 'james.wilson@example.com', 9, NULL, 'Guest'),
('Olivia Lee', 'olivia.lee@example.com', 10, NULL, 'Guest'),
('Michael Harris', 'michael.harris@example.com', NULL, 1, 'Host'),
('Laura Robinson', 'laura.robinson@example.com', NULL, 2, 'Host'),
('David Martinez', 'david.martinez@example.com', NULL, 3, 'Host'),
('Isabella Thomas', 'isabella.thomas@example.com', NULL, 4, 'Host'),
('Lucas Garcia', 'lucas.garcia@example.com', NULL, 5, 'Host'),
('Mia Hernandez', 'mia.hernandez@example.com', NULL, 6, 'Host'),
('Ethan Carter', 'ethan.carter@example.com', NULL, 7, 'Host'),
('Amelia Young', 'amelia.young@example.com', NULL, 8, 'Host'),
('Benjamin Walker', 'benjamin.walker@example.com', NULL, 9, 'Host'),
('Harper Allen', 'harper.allen@example.com', NULL, 10, 'Host'),
('Jack King', 'jack.king@example.com', 11, NULL, 'Guest'),
('Lily Scott', 'lily.scott@example.com', 12, NULL, 'Guest'),
('William Adams', 'william.adams@example.com', 13, NULL, 'Guest'),
('Avery Nelson', 'avery.nelson@example.com', 14, NULL, 'Guest'),
('Chloe Carter', 'chloe.carter@example.com', 15, NULL, 'Guest');

-- Insert sample data into ReferralReward
INSERT INTO ReferralReward (ReferrerID, RewardDescription, RedemptionStatus) VALUES
(1, 'Free 1-night stay at any listed property', 'Pending'),
(2, '10% discount on next booking', 'Redeemed'),
(3, 'Exclusive access to VIP properties for 1 month', 'Pending'),
(4, 'Gift voucher worth $50', 'Redeemed'),
(5, 'Free upgrade to a premium property for 1 stay', 'Pending'),
(6, '10% discount on next booking', 'Pending'),
(7, 'Free 1-night stay at any listed property', 'Redeemed'),
(8, 'Exclusive access to VIP properties for 1 month', 'Pending'),
(9, 'Gift voucher worth $50', 'Redeemed'),
(10, 'Free upgrade to a premium property for 1 stay', 'Pending'),
(11, '10% discount on next booking', 'Redeemed'),
(12, 'Free 1-night stay at any listed property', 'Pending'),
(13, 'Exclusive access to VIP properties for 1 month', 'Pending'),
(14, 'Gift voucher worth $50', 'Redeemed'),
(15, 'Free upgrade to a premium property for 1 stay', 'Pending'),
(16, '10% discount on next booking', 'Redeemed'),
(17, 'Free 1-night stay at any listed property', 'Pending'),
(18, 'Exclusive access to VIP properties for 1 month', 'Redeemed'),
(19, 'Gift voucher worth $50', 'Pending'),
(20, 'Free upgrade to a premium property for 1 stay', 'Redeemed'),
(21, '10% discount on next booking', 'Pending'),
(22, 'Free 1-night stay at any listed property', 'Redeemed'),
(23, 'Exclusive access to VIP properties for 1 month', 'Pending'),
(24, 'Gift voucher worth $50', 'Redeemed'),
(25, 'Free upgrade to a premium property for 1 stay', 'Pending');

-- TEST CASE
-- Let's create a test scenario where a guest books a property, makes a payment, and leaves a review. 
-- This will test the relationship between the Guest, Property, Booking, Payment, and Review tables.

-- 1. Insert Data for a New Booking 
-- Assuming the GuestID is 1 and PropertyID is 1
INSERT INTO Booking (GuestID, PropertyID, CheckInDate, CheckOutDate, PaymentStatus, BookingDate)
VALUES (1, 1, '2025-02-01', '2025-02-10', 'Pending', CURDATE());


-- 2.Process the payment for the booking
-- Assuming the BookingID for the above booking is 1 and payment of 500.00
INSERT INTO Payment (BookingID, Amount, PaymentDate, PaymentMethod)
VALUES (1, 500.00, CURDATE(), 'Credit Card');

-- 3. Update Payment Status
-- Updating payment status to 'Successful'
UPDATE Booking
SET PaymentStatus = 'Successful'
WHERE BookingID = 1;

-- 4.Leave a Review
-- Assuming the GuestID is 1 and PropertyID is 1, and a rating of 4
INSERT INTO Review (GuestID, PropertyID, Rating, Comment, ReviewDate)
VALUES (1, 1, 4, 'Great experience, will come back!', CURDATE());


-- 5. Query to Check Data Integrity
-- Check the booking details
SELECT * FROM Booking WHERE BookingID = 1;

-- Check the payment details
SELECT * FROM Payment WHERE BookingID = 1;

-- Check the review details
SELECT * FROM Review WHERE GuestID = 1 AND PropertyID = 1;


