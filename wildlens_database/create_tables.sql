-- Table: users
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    avatar TEXT,
    bio TEXT,
    total_scans INT DEFAULT 0,
    animals_identified INT DEFAULT 0,
    favorite_biome VARCHAR(255),
    member_since DATE
);

-- Table: ecosystems
CREATE TABLE ecosystems (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    animal_count INT DEFAULT 0,
    location VARCHAR(255),
    image TEXT,
    description TEXT
);

-- Table: animals (species)
CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255),
    category VARCHAR(255),
    image TEXT,
    endangered BOOLEAN DEFAULT FALSE,
    tags TEXT[],
    conservation_status VARCHAR(255),
    habitat VARCHAR(255),
    footprint_type VARCHAR(255),
    ecosystem_id INT REFERENCES ecosystems(id)
);

-- Table: scans
CREATE TABLE scans (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    image_url TEXT NOT NULL,
    animal_name VARCHAR(255) NOT NULL,
    confidence FLOAT NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    scan_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    details TEXT
);

-- Table: activity_history
CREATE TABLE activity_history (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    type VARCHAR(50),
    title VARCHAR(255),
    activity_date DATE,
    location VARCHAR(255),
    image TEXT
);

-- Table: favorites
CREATE TABLE favorites (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    animal_id INT REFERENCES animals(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table: badges
CREATE TABLE badges (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    badge_name VARCHAR(255),
    badge_image TEXT,
    awarded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
