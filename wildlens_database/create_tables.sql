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
    details TEXT,
    animal_id INT REFERENCES animals(id)
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

-- INSERT: Ecosystems
INSERT INTO ecosystems (id, name, animal_count, location, image, description) VALUES
(1, 'Zones Humides', 4, 'Amérique du Nord', 'https://www.photo-paysage.com/albums/userpics/10001/normal_Zone-humide-au-bord-du-Lac-du-Der.jpg', 'Rivières, marais et zones humides.'),
(2, 'Forêts et Montagnes', 15, 'Amérique du Nord', 'https://www.curieux.live/wp-content/uploads/2022/03/misty-mountain-forest-2022-03-02-04-16-48-utc-scaled.jpg', 'Forêts mixtes, bois, zones escarpées.'),
(3, 'Zones Habitées', 5, 'Partout', 'https://www.hess.eu/fileadmin/_processed_/0/e/csm_florian-wehde-1092251-unsplash_b5707fe7e4.jpg', 'Zones rurales et urbaines, habitations humaines.'),
(4, 'Savane et Afrique', 1, 'Afrique', 'https://media.istockphoto.com/id/177145956/fr/photo/savane-africaine-au-kenya.jpg?s=612x612&w=0&k=20&c=V7l7WkzpX3ES0E0FqzejMQmLt-iNchExCjqjYCWkLyY=', 'Savane africaine.');

-- INSERT: Animals
INSERT INTO animals (name, scientific_name, category, image, endangered, tags, conservation_status, habitat, footprint_type, ecosystem_id) VALUES
('bernache_du_canada','Branta canadensis','Oiseau','https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcRc-toccFmCD_tlLpY0_PEQ6otDMv5XL71AYzdwVKIeedzyjcYdO3-9VmiLZoGU9KOGf89PxKRVMLJ6ANCZtHsjUg',false,'{oiseau,migrateur}','Préoccupation mineure','Zones humides','pattes palmées',1),
('castor','Castor canadensis','Mammifère','https://jardinage.lemonde.fr/images/dossiers/2017-09/castor-061727.jpg',false,'{rongeur,aquatique}','Préoccupation mineure','Rivières','empreinte large',1),
('loutre_de_riviere','Lontra canadensis','Mammifère','https://www.francebleu.fr/s3/cruiser-production/2021/07/a9c87aa8-8bae-4a46-bc15-b07ae2022cf1/1200x680_loutre.jpg',false,'{aquatique,curieux}','Préoccupation mineure','Rivières','pattes palmées',1),
('vison_americain','Neovison vison','Mammifère','https://5fdbcabe.delivery.rocketcdn.me/wp-content/uploads/2025/03/Europaeischer-und-Amerikanischer-Nerz-Wildtiere-in-Europa.webp',false,'{aquatique,fourrure}','Préoccupation mineure','Rivières','pattes palmées',1),

('cerf_mulet','Odocoileus hemionus','Mammifère','https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQUnBq_sA6rm_XAZAz8BfGWhtrWhtZPgwvfnXnPg5Ar_VWQudsFKCim0xRHqXhFzeh5szBF6_wMcpLM8qY7JXpkBA',false,'{herbivore,sauvage}','Préoccupation mineure','Forêts','sabots',2),
('coyote','Canis latrans','Mammifère','https://cdn.britannica.com/45/125545-050-B705597E/Coyote.jpg',false,'{canidé,prédateur}','Préoccupation mineure','Prairies','pattes',2),
('dindon_sauvage','Meleagris gallopavo','Oiseau','https://www.upa.qc.ca/fileadmin/mauricie/Dinde-sauvage_01.jpg',false,'{oiseau,terrestre}','Préoccupation mineure','Forêts','griffes',2),
('ecureuil','Sciurus vulgaris','Mammifère','https://www.info-rongeurs.fr/wp-content/uploads/2020/02/ecureuil.jpg',false,'{rongeur,arboricole}','Préoccupation mineure','Forêts','petites pattes',2),
('ecureuil_gris_occidental','Sciurus griseus','Mammifère','https://img.freepik.com/photos-gratuite/capture-ecran-ecureuil-gris-est_181624-51118.jpg?semt=ais_hybrid&w=740',false,'{rongeur,forêt}','Préoccupation mineure','Forêts','petites pattes',2),
('loup','Canis lupus','Mammifère','https://d1jyxxz9imt9yb.cloudfront.net/medialib/4452/image/s768x1300/JohnEMarriott_2009-10_BanffNationalPark-Alberta-Canada_WolfHowling_wlf0054_reduced.jpg',false,'{canidé,sauvage}','Préoccupation mineure','Forêts','pattes',2),
('lynx','Lynx lynx','Mammifère','https://sf1.lechasseurfrancais.com/wp-content/uploads/2021/12/jeune-lynx.jpg',false,'{félin,sauvage}','Préoccupation mineure','Montagnes','pattes',2),
('lynx_roux','Lynx rufus','Mammifère','https://images.rtl.fr/~c/1200v800/rtl/www/1406334-un-lynx-roux-illustration.jpg',false,'{félin,sauvage}','Préoccupation mineure','Forêts','pattes',2),
('mouffette','Mephitis mephitis','Mammifère','https://www.francebleu.fr/s3/cruiser-production/2022/11/8db709db-fd94-4dda-a328-8cc575cc403a/1200x680_maxnewsfrfour605678.jpg',false,'{nocturne,défense}','Préoccupation mineure','Zones boisées','pattes',2),
('ours','Ursus arctos','Mammifère','https://sf1.lechasseurfrancais.com/wp-content/uploads/2024/06/capture-decran-2024-06-02-a-10.08.04-365x200.png',false,'{carnivore,forêt}','Préoccupation mineure','Forêts','grandes pattes',2),
('ours_noir','Ursus americanus','Mammifère','https://reseauzec.com/wp-content/uploads/gestionnaire//1_articles_1757.jpeg',false,'{omnivore,bois}','Préoccupation mineure','Forêts','grandes pattes',2),
('puma','Puma concolor','Mammifère','https://korke1.b-cdn.net/wp-content/uploads/2024/07/Torres-del-Paine-Puma-2-circuit.jpg',false,'{prédateur,solitaire}','Préoccupation mineure','Montagnes','pattes',2),
('raton_laveur','Procyon lotor','Mammifère','https://www.fdc63.chasseauvergnerhonealpes.com/wp-content/uploads/sites/5/2018/07/raton-1.jpg',false,'{nocturne,urbain}','Préoccupation mineure','Forêts urbaines','pattes',2),
('renard','Vulpes vulpes','Mammifère','https://www.notrenature.be/media/cache/fb_og_image/uploads/media/5e720ed9b63d4/shutterstock-162620897-630x420.jpg',false,'{rusé,forêt}','Préoccupation mineure','Forêts','pattes',2),
('renard_gris','Urocyon cinereoargenteus','Mammifère','https://t4.ftcdn.net/jpg/14/17/55/65/360_F_1417556529_qac8WIRjCNNgiwTkHQRF7H2jg0nbR2vn.jpg',false,'{grimpeur,bois}','Préoccupation mineure','Forêts','pattes',2),

('chat','Felis catus','Mammifère','https://www.la-spa.fr/app/app/uploads/2023/07/prendre-soin_duree-vie-chat.jpg',false,'{domestique}','Non applicable','Habitations','pattes',3),
('cheval','Equus ferus caballus','Mammifère','https://www.radiofrance.fr/s3/cruiser-production/2021/03/e51f683c-1f29-4136-8e62-31baa8fbf95a/1200x680_origines-equides-cheval.webp',false,'{domestique,herbivore}','Non applicable','Pâturages','sabots',3),
('chien','Canis lupus familiaris','Mammifère','https://ik.imagekit.io/yynn3ntzglc/cms/contenu2_focus_races_chiens_5f06fdcf70_3bm-3iiU_.jpg',false,'{domestique}','Non applicable','Habitations','pattes',3),
('lapin','Oryctolagus cuniculus','Mammifère','https://images.onlinepets.com/uploads/2021/02/L2_20-scaled-e1703240849893.jpg',false,'{rongeur,domestique}','Préoccupation mineure','Campagne','pattes',3),
('rat','Rattus rattus','Rongeur','https://conseils.wanimo.com/veterinaire/wp-content/uploads/2016/04/iStock-104522789.jpg',false,'{urbain}','Préoccupation mineure','Villes','pattes',3),
('souris','Mus musculus','Rongeur','https://www.abatextermination.ca/wp-content/uploads/2012/01/souris_21.jpg',false,'{petit,rapide}','Préoccupation mineure','Habitations','petites pattes',3),

('elephant','Loxodonta africana','Mammifère','https://cdn.shortpixel.ai/spai2/q_glossy+w_1082+to_auto+ret_img/www.fauna-flora.org/wp-content/uploads/2017/11/Elephant-Stephanie-Foote-1.jpg',true,'{herbivore,afrique}','Vulnérable','Savane','pieds ronds',4);
