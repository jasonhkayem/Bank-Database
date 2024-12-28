-- Create the Bank database if it does not exist and use it
CREATE DATABASE IF NOT EXISTS Bank;
USE Bank;

-- Customer Table with improved data types
CREATE TABLE IF NOT EXISTS Customer (
  id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  date_of_birth DATE NOT NULL,
  gender ENUM('Male', 'Female', 'Other') NOT NULL,
  PRIMARY KEY (id)
);

-- Branch Table with improved data types
CREATE TABLE IF NOT EXISTS Branch (
  id INT NOT NULL AUTO_INCREMENT,
  name VARCHAR(100) NOT NULL,
  address VARCHAR(255) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY (name)
);

-- Card Table with improved data types and constraints
CREATE TABLE IF NOT EXISTS Card (
  id INT NOT NULL AUTO_INCREMENT,
  number VARCHAR(50) NOT NULL,
  expiration_date DATE NOT NULL,
  is_blocked TINYINT(1) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY (number)
);

-- Account Table with improved constraints and data types
CREATE TABLE IF NOT EXISTS Account (
  id INT NOT NULL AUTO_INCREMENT,
  customer_id INT DEFAULT NULL,
  card_id INT DEFAULT NULL,
  balance DECIMAL(12, 2) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  FOREIGN KEY (customer_id) REFERENCES Customer(id) ON DELETE SET NULL ON UPDATE CASCADE,
  FOREIGN KEY (card_id) REFERENCES Card(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Loan_type Table with improved data types
CREATE TABLE IF NOT EXISTS Loan_type (
  id INT NOT NULL AUTO_INCREMENT,
  type VARCHAR(100) NOT NULL,
  base_amount DECIMAL(12, 3) NOT NULL DEFAULT 0,
  base_interest_rate DECIMAL(12, 3) NOT NULL DEFAULT 0,
  PRIMARY KEY (id),
  UNIQUE KEY (type)
);

-- Loan Table with improved foreign key constraints
CREATE TABLE IF NOT EXISTS Loan (
  id INT NOT NULL AUTO_INCREMENT,
  account_id INT DEFAULT NULL,
  loan_type_id INT DEFAULT NULL,
  amount_paid DECIMAL(12, 3) NOT NULL DEFAULT 0,
  start_date DATE NOT NULL,
  due_date DATE NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (loan_type_id) REFERENCES Loan_type(id) ON DELETE SET NULL ON UPDATE CASCADE
);

-- Transaction Table with improved foreign key constraints
CREATE TABLE IF NOT EXISTS Transaction (
  id INT NOT NULL AUTO_INCREMENT,
  account_id INT DEFAULT NULL,
  amount DECIMAL(12, 3) NOT NULL DEFAULT 0,
  date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id),
  FOREIGN KEY (account_id) REFERENCES Account(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Customer_Branch Table with improved foreign key constraints
CREATE TABLE IF NOT EXISTS Customer_Branch (
  id INT NOT NULL AUTO_INCREMENT,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  PRIMARY KEY (id),
  FOREIGN KEY (customer_id) REFERENCES Customer(id) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (branch_id) REFERENCES Branch(id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Create a trigger to update account balance after each transaction
DELIMITER //
CREATE TRIGGER update_account_balance AFTER INSERT ON Transaction
FOR EACH ROW
BEGIN
    UPDATE Account
    SET balance = balance - NEW.amount
    WHERE id = NEW.account_id;
END;
//
DELIMITER ;
