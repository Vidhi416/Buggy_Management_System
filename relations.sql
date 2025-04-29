delete from users;
delete from drivers;
delete from buggy;
delete from routes;
delete from bookings;
delete from maintainance;

INSERT INTO users VALUES (1, 'Alice Johnson', 'alice@example.com', 'pass123', 'user', '1234567890');
INSERT INTO users VALUES (2, 'Bob Smith', 'bob@example.com', 'secure456', 'user', '1234567891');
INSERT INTO users VALUES (3, 'Charlie Brown', 'charlie@example.com', 'abc123', 'user', '1234567892');
INSERT INTO users VALUES (4, 'David Miller', 'david@example.com', 'pass789', 'admin', '1234567893');
INSERT INTO users VALUES (5, 'Eve White', 'eve@example.com', 'password', 'user', '1234567894');
INSERT INTO users VALUES (6, 'Frank Wright', 'frank@example.com', 'wright321', 'user', '1234567895');
INSERT INTO users VALUES (7, 'Grace Lee', 'grace@example.com', 'gracepass', 'user', '1234567896');
INSERT INTO users VALUES (8, 'Henry Ford', 'henry@example.com', 'henry123', 'admin', '1234567897');
INSERT INTO users VALUES (9, 'Ivy Taylor', 'ivy@example.com', 'ivysecure', 'user', '1234567898');
INSERT INTO users VALUES (10, 'Jack Wilson', 'jack@example.com', 'jackson123', 'user', '1234567899');


INSERT INTO drivers VALUES (1, 'John Doe', 'john.doe@example.com', 'driver123', '2234567890');
INSERT INTO drivers VALUES (2, 'Mike Ross', 'mike.ross@example.com', 'mikeross', '2234567891');
INSERT INTO drivers VALUES (3, 'Rachel Green', 'rachel.green@example.com', 'rachelpass', '2234567892');
INSERT INTO drivers VALUES (4, 'Monica Geller', 'monica.geller@example.com', 'monica123', '2234567893');
INSERT INTO drivers VALUES (5, 'Chandler Bing', 'chandler.bing@example.com', 'bing123', '2234567894');
INSERT INTO drivers VALUES (6, 'Joey Tribbiani', 'joey.tribbiani@example.com', 'joeypass', '2234567895');
INSERT INTO drivers VALUES (7, 'Ross Geller', 'ross.geller@example.com', 'rosspass', '2234567896');
INSERT INTO drivers VALUES (8, 'Phoebe Buffay', 'phoebe.buffay@example.com', 'phoebepass', '2234567897');
INSERT INTO drivers VALUES (9, 'Janice Litman', 'janice.litman@example.com', 'ohmygod', '2234567898');
INSERT INTO drivers VALUES (10, 'Gunther Central', 'gunther.central@example.com', 'gunther123', '2234567899');


INSERT INTO buggy VALUES (1, 'Model A', 4, 'available', 'Manipal', 1);
INSERT INTO buggy VALUES (2, 'Model B', 6, 'unavailable', 'Udupi', 2);
INSERT INTO buggy VALUES (3, 'Model C', 2, 'unavailable', 'Malpe', 3);
INSERT INTO buggy VALUES (4, 'Model D', 4, 'available', 'Kundapur', 4);
INSERT INTO buggy VALUES (5, 'Model E', 8, 'available', 'Byndoor', 5);
INSERT INTO buggy VALUES (6, 'Model F', 4, 'unavailable', 'Murudeshwar', 6);
INSERT INTO buggy VALUES (7, 'Model G', 6, 'available', 'Honnavar', 7);
INSERT INTO buggy VALUES (8, 'Model H', 3, 'unavailable', 'Gokarna', 8);
INSERT INTO buggy VALUES (9, 'Model I', 5, 'available', 'Karwar', 9);
INSERT INTO buggy VALUES (10, 'Model J', 7, 'unavailable', 'Mangalore', 10);


INSERT INTO routes VALUES ('Manipal', 'Udupi');
INSERT INTO routes VALUES ('Udupi', 'Malpe');
INSERT INTO routes VALUES ('Malpe', 'Kundapur');
INSERT INTO routes VALUES ('Kundapur', 'Byndoor');
INSERT INTO routes VALUES ('Byndoor', 'Murudeshwar');
INSERT INTO routes VALUES ('Murudeshwar', 'Honnavar');
INSERT INTO routes VALUES ('Honnavar', 'Gokarna');
INSERT INTO routes VALUES ('Gokarna', 'Karwar');
INSERT INTO routes VALUES ('Karwar', 'Mangalore');
INSERT INTO routes VALUES ('Mangalore', 'Manipal');

INSERT INTO maintainance VALUES (CURRENT_DATE - 30, 1, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 20, 2, 'pending');
INSERT INTO maintainance VALUES (CURRENT_DATE - 10, 3, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 25, 4, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 15, 5, 'pending');
INSERT INTO maintainance VALUES (CURRENT_DATE - 5, 6, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 12, 7, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 8, 8, 'pending');
INSERT INTO maintainance VALUES (CURRENT_DATE - 18, 9, 'completed');
INSERT INTO maintainance VALUES (CURRENT_DATE - 22, 10, 'completed');


select * from users;
select * from drivers;
select * from buggy;
select * from routes;
select * from bookings;
select * from maintainance;



