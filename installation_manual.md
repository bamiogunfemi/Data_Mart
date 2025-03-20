# Installation Manual

The database server of choice for the airbnb project is MySQL. This manual provides instructions for installing and configuring the database system.

## Prerequisites

Before you begin, ensure you have:

- MySQL Server 5.7 or higher installed
- MySQL Workbench or another MySQL client (optional, but recommended)
- Basic knowledge of SQL and database operations

## Setting up MySQL

You will need to install MySQL from the official [MySQL website](https://dev.mysql.com/downloads/) following their installation instructions for your operating system. This installs both the MySQL server and client tools.

## Creating our database

To create our database, tables and insert data into each table, we need to run the following commands:

1. Now that we have set up MySQL, we can connect to the MySQL server using the command below. For simplicity sake, the files used to provision our airbnb database and data should be in the same directory as the one we are running the commands, if not we will need to `cd` into the folder.

```bash
mysql -u [username] -p
```

2. After connecting to the database, we need to create our airbnb database and tables. The `schema.sql` file does that for us. This file drops the `airbnbSystem` database if it already exists, then creates the database so we have a clean db, switches to the database, and creates all the tables with their relationships. Run the command below to create the database:

```sql
source schema.sql
```

3. Finally, we need to insert data into the tables in the database. The file that contains the data is the `data.sql`. Run the command below to insert the entries:

```sql
source data.sql
```

## Verifying installation

After running the scripts, verify that the database has been created successfully by running:

```sql
USE airbnbSystem;
SHOW TABLES;
```

You should see a list of all tables that were created. The expected tables include:

- Guest
- Host
- Location
- Property
- Booking
- Payment
- Review
- And many others

## Database Structure Overview

The Airbnb database consists of the following key tables:

1. **Guest**: Stores information about users who book properties
2. **Host**: Contains details about users who list properties
3. **Property**: Stores property listings with details like price, type, and amenities
4. **Location**: Contains geographical information for properties
5. **Booking**: Records booking information including check-in/check-out dates
6. **Payment**: Stores payment details for bookings
7. **Review**: Contains reviews and ratings for properties
8. **User**: Maps users to their roles (Guest, Host)
9. **LoyaltyProgram**: Manages guest loyalty points and rewards
10. **Promotion**: Stores promotional offers for properties
11. **MaintenanceRequest**: Tracks property maintenance issues
12. **Calendar**: Manages property availability dates
13. **Amenity**: Lists available amenities for properties
14. **Type**: Defines property types
15. **Rules**: Documents property rules
16. **Transaction**: Records payment transactions
17. **ReviewFlag**: Tracks flagged/reported reviews
18. **ReferralReward**: Manages referral rewards for guests

## Sample Queries

Here are some sample queries to test your installation:

1. View all properties:

```sql
SELECT * FROM Property;
```

2. View bookings with guest information:

```sql
SELECT b.BookingID, g.Name AS GuestName, p.Price, b.CheckInDate, b.CheckOutDate
FROM Booking b
JOIN Guest g ON b.GuestID = g.GuestID
JOIN Property p ON b.PropertyID = p.PropertyID;
```

3. View highest-rated properties:

```sql
SELECT p.PropertyID, p.Type, AVG(r.Rating) AS AverageRating
FROM Property p
JOIN Review r ON p.PropertyID = r.PropertyID
GROUP BY p.PropertyID
ORDER BY AverageRating DESC
LIMIT 5;
```

## Troubleshooting

If you encounter issues during installation:

1. **Database already exists error**: If you see an error about the database already existing, you can either:

   - Drop the existing database with `DROP DATABASE airbnbSystem;` before running the script again
   - Comment out the `DROP DATABASE` and `CREATE DATABASE` lines in the script to preserve your existing database

2. **Syntax errors**: Ensure you're using a compatible version of MySQL (5.7 or higher)

3. **Foreign key constraint failures**: The scripts are designed to insert data in the correct order to avoid constraint violations. If you're running parts of the script separately, ensure you run the table creation and data insertion in the proper sequence.

4. **File not found**: Ensure the paths to your SQL files are correct when using the `source` command. If the files are not in your current directory, you may need to provide the full path.
