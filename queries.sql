
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TYPE organization AS ENUM ('university', 'institute', 'cathedra');

-- Table for storing information about scientists
CREATE TABLE IF NOT EXISTS scientists (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    academic_title VARCHAR(50),
    research_area VARCHAR(255),
    email VARCHAR(255),
    profile_url TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS organizations (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type organization NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS scientist_organization (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    scientist_id UUID NOT NULL REFERENCES scientists(id) ON DELETE CASCADE,
    organization_id UUID NOT NULL REFERENCES organizations(id) ON DELETE CASCADE
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing publications of scientists
CREATE TABLE publications (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    title TEXT NOT NULL,
    journal VARCHAR(255) NOT NULL,
    publication_date DATE NOT NULL,
    citations_count INTEGER NOT NULL,
    impact_factor FLOAT NOT NULL,
    scientist_id UUID INTEGER REFERENCES scientists(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing bibliometric indicators of scientists
CREATE TABLE bibliometrics (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    h_index INTEGER NOT NULL,
    citation_count INTEGER NOT NULL,
    publication_count INTEGER NOT NULL,
    ministerial_score FLOAT NOT NULL,
    scientist_id UUID INTEGER REFERENCES scientists(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing user's favorite scientists
CREATE TABLE favorites (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID INTEGER NOT NULL, -- assuming a users table exists
    scientist_id UUID INTEGER REFERENCES scientists(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);


-- Table for storing information about users
CREATE TABLE users (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    is_admin BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Table for storing logs of user activities
CREATE TABLE activity_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID INTEGER REFERENCES users(id) ON DELETE SET NULL,
    action TEXT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing system error logs or application events
CREATE TABLE system_logs (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    level VARCHAR(50) NOT NULL,  -- Level of log (e.g., 'ERROR', 'INFO', 'DEBUG')
    message TEXT NOT NULL,       -- The actual log message
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Table for storing user settings (preferences)
CREATE TABLE user_settings (
    id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
    user_id UUID INTEGER REFERENCES users(id) ON DELETE CASCADE,
    language VARCHAR(10) DEFAULT 'pl',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Adding foreign key constraints to favorites table to reference users table
ALTER TABLE favorites ADD CONSTRAINT fk_user_id UUID FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
