-- Table habitat (DOIT ÊTRE CRÉÉE EN PREMIER)
CREATE TABLE habitat (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL
);

-- Table species
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    description TEXT NOT NULL,
    common_name VARCHAR(255) NOT NULL,
    scientific_name VARCHAR(255) NOT NULL,
    family VARCHAR(255),
    size VARCHAR(255),
    region VARCHAR(255),
    habitat_id INT REFERENCES habitat(id),  -- Référence maintenant valide
    fun_fact TEXT,
    animal_image_url TEXT
);

-- Table prints
CREATE TABLE prints (
    id SERIAL PRIMARY KEY,
    species_id INT REFERENCES species(id),
    image BYTEA NOT NULL,
    capture_date DATE,
    location VARCHAR(255),
    analysis_score INT
);
