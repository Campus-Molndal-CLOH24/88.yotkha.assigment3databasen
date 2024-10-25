-- Active: 1728752329110@@localhost@3306@orderproducts

CREATE TABLE client (
    client_id INT AUTO_INCREMENT PRIMARY KEY,
    client_name VARCHAR(255) NOT NULL,
    client_email VARCHAR(255) NOT NULL,
    client_phone VARCHAR(255) NOT NULL
);

CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    product_description VARCHAR(255),
    product_price DECIMAL(10, 2) NOT NULL
);

-- Create the transportation table
CREATE TABLE transportation (
    transportation_id INT AUTO_INCREMENT PRIMARY KEY,
    transportation_name VARCHAR(255) NOT NULL
);

CREATE TABLE `order` (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATE NOT NULL,
    order_status VARCHAR(255) NOT NULL,
    order_total DECIMAL(10, 2),
    client_id INT,
    transportation_id INT,
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (transportation_id) REFERENCES transportation(transportation_id)
);

CREATE TABLE order_detail (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `order`(order_id),
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);


INSERT INTO client (client_name, client_email, client_phone) VALUES
('Alice Johnson', 'alice.johnson@example.com', '555-1234'),
('Bob Smith', 'bob.smith@example.com', '555-5678'),
('Charlie Brown', 'charlie.brown@example.com', '555-8765'),
('Diana Prince', 'diana.prince@example.com', '555-4321'),
('Ethan Hunt', 'ethan.hunt@example.com', '555-2468');

INSERT INTO product (product_name, product_description, product_price) VALUES
('Laptop', 'High performance laptop', 999.99),
('Smartphone', 'Latest model smartphone', 699.99),
('Headphones', 'Noise-cancelling headphones', 199.99),
('Smartwatch', 'Fitness tracking smartwatch', 249.99),
('Tablet', '10-inch display tablet', 299.99);

INSERT INTO transportation (transportation_name) VALUES
('FedEx'),
('UPS'),
('DHL'),
('USPS'),
('Local Courier');

INSERT INTO `order` (order_date, order_status, order_total, client_id, transportation_id) VALUES
('2024-10-01', 'Shipped', 1249.98, 1, 1),  -- Alice Johnson
('2024-10-02', 'Delivered', 699.99, 2, 2), -- Bob Smith
('2024-10-03', 'Processing', 199.99, 3, 3), -- Charlie Brown
('2024-10-04', 'Cancelled', 299.99, 4, 4),  -- Diana Prince
('2024-10-05', 'Shipped', 1249.99, 5, 5);  -- Ethan Hunt

INSERT INTO order_detail (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 999.99),  -- Laptop for Alice
(1, 3, 1, 199.99),  -- Headphones for Alice
(2, 2, 1, 699.99),  -- Smartphone for Bob
(3, 3, 1, 199.99),  -- Headphones for Charlie
(4, 5, 1, 299.99),  -- Tablet for Diana
(5, 1, 1, 999.99),  -- Laptop for Ethan
(5, 4, 1, 249.99);  -- Smartwatch for Ethan



SELECT 
    c.client_name, 
    p.product_name, 
    o.order_date, 
    o.order_status,
    SUM(od.price * od.quantity) AS total_order_price
FROM 
    client c
JOIN 
    orders o ON c.client_id = o.client_id
JOIN 
    order_detail od ON o.order_id = od.order_id
JOIN 
    product p ON od.product_id = p.product_id
GROUP BY 
    c.client_name, p.product_name, o.order_date, o.order_status
HAVING 
    total_order_price > 100
ORDER BY 
    total_order_price DESC;

RENAME TABLE `order` TO `orders`;

