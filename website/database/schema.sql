-- USERS
CREATE TYPE user_role AS ENUM ('customer', 'professional');
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
	name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    pass VARCHAR(255) NOT NULL,
    information TEXT,
    role user_role NOT NULL
);

-- PROFESSIONAL PROFILE
CREATE TABLE professional_profile (
    user_id INT PRIMARY KEY,
    rating INT,
    is_verified BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- CUSTOMER
CREATE TABLE customer (
    customer_id INT PRIMARY KEY,
    FOREIGN KEY (customer_id) REFERENCES users(id)
);

-- TAGS
CREATE TABLE tags (
    id SERIAL PRIMARY KEY,
    tag_name VARCHAR(100) UNIQUE
);

-- CUSTOMER PREFERENCES
CREATE TABLE customer_preferences (
    customer_id INT,
    tag_name VARCHAR(100),
    PRIMARY KEY (customer_id, tag_name),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (tag_name) REFERENCES tags(tag_name)
);

-- EVENTS
CREATE TABLE events (
    id SERIAL PRIMARY KEY,
    publisher_id INT,
    venue VARCHAR(255),
    sdate DATE,
    edate DATE,
    target VARCHAR(255),
    description TEXT,
    FOREIGN KEY (publisher_id) REFERENCES professional_profile(user_id)
);

-- EVENTS TAGS
CREATE TABLE event_tags (
    event_id INT,
    tag_name VARCHAR(100),
    PRIMARY KEY (event_id, tag_name),
    FOREIGN KEY (event_id) REFERENCES events(id),
    FOREIGN KEY (tag_name) REFERENCES tags(tag_name)
);

-- FRIENDS
CREATE TABLE friends (
    user1_id INT,
    user2_id INT,
    PRIMARY KEY (user1_id, user2_id),
    FOREIGN KEY (user1_id) REFERENCES customer(customer_id),
    FOREIGN KEY (user2_id) REFERENCES customer(customer_id),
    CHECK (user1_id < user2_id)
);

-- FOLLOWS
CREATE TABLE follows (
    customer_id INT,
    professional_id INT,
    PRIMARY KEY (customer_id, professional_id),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (professional_id) REFERENCES professional_profile(user_id)
);

-- CHAT
CREATE TABLE chat (
    id SERIAL PRIMARY KEY
);

-- CHAT PARTICIPANTS
CREATE TABLE chat_participants (
    chat_id INT,
    user_id INT,
    PRIMARY KEY (chat_id, user_id),
    FOREIGN KEY (chat_id) REFERENCES chat(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- MESSAGE
CREATE TABLE message (
    id SERIAL PRIMARY KEY,
    chat_id INT,
    sender_id INT,
    content TEXT,
    sent_at TIMESTAMP,
    FOREIGN KEY (chat_id) REFERENCES chat(id),
    FOREIGN KEY (sender_id) REFERENCES users(id)
);

-- PUBLICATION
CREATE TABLE publication (
    id SERIAL PRIMARY KEY,
    user_id INT,
    media VARCHAR(255),
    publish_date DATE,
    information TEXT,
    likes INT DEFAULT 0,
    event_id INT,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- COMMENTS
CREATE TABLE comments (
    publication_id INT,
    user_id INT PRIMARY KEY,
    information TEXT,
    publish_date DATE,
    likes INT DEFAULT 0,
    FOREIGN KEY (publication_id) REFERENCES publication(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- APPLICATION
CREATE TABLE application (
    id SERIAL PRIMARY KEY,
    publisher_id INT,
    event_id INT,
    information TEXT,
    contact VARCHAR(255),
    FOREIGN KEY (publisher_id) REFERENCES professional_profile(user_id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- PROFESSIONAL REVIEW
CREATE TABLE professional_review (
    user_id INT,
    professional_id INT,
    rating INT,
    sent_date DATE,
    information TEXT,
    PRIMARY KEY (user_id, professional_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (professional_id) REFERENCES professional_profile(user_id)
);

-- EVENTS REVIEW
CREATE TABLE event_review (
    user_id INT,
    event_id INT,
    rating INT,
    sent_date DATE,
    information TEXT,
    PRIMARY KEY (user_id, event_id),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- PROFESSIONAL HISTORY
CREATE TABLE professional_history (
    professional_id INT,
    event_id INT,
    PRIMARY KEY (professional_id, event_id),
    FOREIGN KEY (professional_id) REFERENCES professional_profile(user_id),
    FOREIGN KEY (event_id) REFERENCES events(id)
);

-- PROFESSIONAL INVITE
CREATE TYPE invite_answer AS ENUM ('pending', 'accepted', 'rejected');
CREATE TABLE professional_invite (
    sender_id INT,
    receiver_id INT,
    invite TEXT,
    answer invite_answer DEFAULT 'pending',
    PRIMARY KEY (sender_id, receiver_id),
    FOREIGN KEY (sender_id) REFERENCES professional_profile(user_id),
    FOREIGN KEY (receiver_id) REFERENCES professional_profile(user_id)
);
