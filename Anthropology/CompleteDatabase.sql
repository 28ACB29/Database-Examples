--
--  Create the anthropology database
--

SET termout ON
SET feedback ON
prompt Building the anthropology database.  Please wait ...
--SET termout OFF
--SET feedback OFF

DROP TABLE Living_Donor                  CASCADE CONSTRAINT;
DROP TABLE Donor                         CASCADE CONSTRAINT;
DROP TABLE Photo                         CASCADE CONSTRAINT;
DROP TABLE X_Ray                         CASCADE CONSTRAINT;
DROP TABLE Donation_Intake_Data          CASCADE CONSTRAINT;
DROP TABLE Decomposition_Data            CASCADE CONSTRAINT;
DROP TABLE Daily_Data                    CASCADE CONSTRAINT;
DROP TABLE Donation_Processing           CASCADE CONSTRAINT;
DROP TABLE Curation_Inventory            CASCADE CONSTRAINT;
DROP TABLE Curation_Zobeck_Measurements  CASCADE CONSTRAINT;
DROP TABLE Curation_Cranial_Measurements CASCADE CONSTRAINT;

CREATE TABLE Living_Donor
(
	Address VARCHAR(200),
	Age INTEGER CHECK (Age > 0),
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID, 'DO[0-9]*-[0-9]*')),
	Name VARCHAR(50),
	Race VARCHAR(9) CHECK (Race IN ('Black','White','Hispanic','Asian')),
	Sex VARCHAR(6) CHECK (Sex IN ('Male','Female')),
	Unique_ID CHAR(36) CHECK (REGEXP_LIKE(Unique_ID , '[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*')),
	PRIMARY KEY (Unique_ID)
);

CREATE TABLE Donor
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID, 'DO[0-9]*-[0-9]*')),
	Unique_ID CHAR(36) CHECK (REGEXP_LIKE(Unique_ID , '[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*')),
	PRIMARY KEY (Donor_ID)
);

--Comment in Photo and X_Ray changed to Comments to resolve conflict with reserved word COMMENT
--Date in Photo and X_Ray changed to Date_Taken to resolve conflict with reserved word DATE

CREATE TABLE Photo
(
	Comments VARCHAR(200),
	Date_Taken DATE,
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID, 'DO[0-9]*-[0-9]*')),
	File_Path VARCHAR(255),
	Name VARCHAR(50),
	Unique_ID CHAR(36) CHECK (REGEXP_LIKE(Unique_ID, '[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*') OR REGEXP_LIKE(Unique_ID, '')),
	PRIMARY KEY (File_Path),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);

--X-Ray changed to X_Ray to avoid a syntax error
--Comment in Photo and X_Ray changed to Comments to resolve conflict with reserved word COMMENT
--Date in Photo and X_Ray changed to Date_Taken to resolve conflict with reserved word DATE

CREATE TABLE X_Ray
(
	Comments VARCHAR(200),
	Date_Taken DATE,
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID, 'DO[0-9]*-[0-9]*')),
	File_Path VARCHAR(255),
	Name VARCHAR(50),
	Unique_ID CHAR(36) CHECK (REGEXP_LIKE(Unique_ID, '[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*-[0-9|A-F|a-f]*') OR REGEXP_LIKE(Unique_ID, '')),
	PRIMARY KEY (File_Path),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);

--Using a character to represent Yes / No is a hack around Oracle's lack of Boolean types

CREATE TABLE Donation_Intake_Data
(
	Blood CHAR(1) CHECK (Blood IN ('Y','N')),
	COD VARCHAR(50),
	DOD DATE,
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID, 'DO[0-9]*-[0-9]*')),
	Foot_Length FLOAT CHECK (Foot_Length > 0.0),
	Hair CHAR(1) CHECK (Hair IN ('Y','N')),
	Nails CHAR(1) CHECK (Nails IN ('Y','N')),
	Arm_Photo VARCHAR(255),
	Face_Photo VARCHAR(255),
	Legs_Photo VARCHAR(255),
	Placement_Photo VARCHAR(255),
	Stake_Photo VARCHAR(255),
	Teeth_Photo VARCHAR(255),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID),
	FOREIGN KEY (Arm_Photo) REFERENCES Photo(File_Path),
	FOREIGN KEY (Face_Photo) REFERENCES Photo(File_Path),
	FOREIGN KEY (Legs_Photo) REFERENCES Photo(File_Path),
	FOREIGN KEY (Placement_Photo) REFERENCES Photo(File_Path),
	FOREIGN KEY (Stake_Photo) REFERENCES Photo(File_Path),
	FOREIGN KEY (Teeth_Photo) REFERENCES Photo(File_Path)
);

--GPS_Location has been broken up into GPS_Longtitude and GPS_Latitude because it was a compound type

CREATE TABLE Decomposition_Data
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Soil_pH FLOAT CHECK (Soil_pH BETWEEN 0.0 AND 14.0),
	GPS_Longtitude FLOAT CHECK (GPS_Longtitude BETWEEN -180.0 AND 180.0),
	GPS_Latitude FLOAT CHECK (GPS_Latitude BETWEEN -90.0 AND 90.0),
	Pickup_Date DATE,
	Burial_Photo#1 VARCHAR(255),
	Burial_Photo#2 VARCHAR(255),
	Burial_Photo#3 VARCHAR(255),
	Burial_Photo#4 VARCHAR(255),
	Pickup_Photo#1 VARCHAR(255),
	Pickup_Photo#2 VARCHAR(255),
	Pickup_Photo#3 VARCHAR(255),
	Pickup_Photo#4 VARCHAR(255),
	Pickup_Photo#5 VARCHAR(255),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID),
	FOREIGN KEY (Burial_Photo#1) REFERENCES Photo(File_Path),
	FOREIGN KEY (Burial_Photo#2) REFERENCES Photo(File_Path),
	FOREIGN KEY (Burial_Photo#3) REFERENCES Photo(File_Path),
	FOREIGN KEY (Burial_Photo#4) REFERENCES Photo(File_Path),
	FOREIGN KEY (Pickup_Photo#1) REFERENCES Photo(File_Path),
	FOREIGN KEY (Pickup_Photo#2) REFERENCES Photo(File_Path),
	FOREIGN KEY (Pickup_Photo#3) REFERENCES Photo(File_Path),
	FOREIGN KEY (Pickup_Photo#4) REFERENCES Photo(File_Path),
	FOREIGN KEY (Pickup_Photo#5) REFERENCES Photo(File_Path)
);

--Date in Photo and X_Ray changed to Date_Taken to resolve conflict with reserved word DATE
--Wind_velocity has been broken up into Wind_Speed and Wind_Direction because it was a compound type

CREATE TABLE Daily_Data
(
	Date_Taken DATE,
	Temperature FLOAT CHECK (Temperature > -40.0),
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Humidity FLOAT CHECK (Humidity BETWEEN 0.0 AND 1.0),
	Wind_Speed FLOAT CHECK (Wind_Speed > 0.0),
	Wind_Direction CHAR(2) CHECK (Wind_Direction IN ('N', 'NE', 'E', 'SE','S', 'SW','W', 'NW')),
	Photo#1 VARCHAR(255),
	Photo#2 VARCHAR(255),
	Photo#3 VARCHAR(255),
	Photo#4 VARCHAR(255),
	Photo#5 VARCHAR(255),
	PRIMARY KEY (Date_Taken),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID),
	FOREIGN KEY (Photo#1) REFERENCES Photo(File_Path),
	FOREIGN KEY (Photo#2) REFERENCES Photo(File_Path),
	FOREIGN KEY (Photo#3) REFERENCES Photo(File_Path),
	FOREIGN KEY (Photo#4) REFERENCES Photo(File_Path),
	FOREIGN KEY (Photo#5) REFERENCES Photo(File_Path)
);

CREATE TABLE Donation_Processing
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Inventory VARCHAR(200),
	Notes VARCHAR(200),
	Long_Bone_X_Ray#1 VARCHAR(255),
	Long_Bone_X_Ray#2 VARCHAR(255),
	Long_Bone_X_Ray#3 VARCHAR(255),
	Long_Bone_X_Ray#4 VARCHAR(255),
	Long_Bone_X_Ray#5 VARCHAR(255),
	Long_Bone_X_Ray#6 VARCHAR(255),
	Long_Bone_X_Ray#7 VARCHAR(255),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID),
	FOREIGN KEY (Long_Bone_X_Ray#1) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#2) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#3) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#4) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#5) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#6) REFERENCES X_Ray(File_Path),
	FOREIGN KEY (Long_Bone_X_Ray#7) REFERENCES X_Ray(File_Path)
);

--These last three tables were truncated for time and performance reasons

CREATE TABLE Curation_Inventory
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Sacrum INTEGER CHECK (Sacrum BETWEEN 1 AND 4),
	Humerus_Left INTEGER CHECK (Humerus_Left BETWEEN 1 AND 4),
	Humerus_Right INTEGER CHECK (Humerus_Right BETWEEN 1 AND 4),
	Femur_Left INTEGER CHECK (Femur_Left BETWEEN 1 AND 4),
	Femur_Right INTEGER CHECK (Femur_Right BETWEEN 1 AND 4),
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);

CREATE TABLE Curation_Zobeck_Measurements
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Clavicle_Maximum_Length_Left FLOAT CHECK (Clavicle_Maximum_Length_Left > 0.0),
	Clavicle_Maximum_Length_Right FLOAT CHECK (Clavicle_Maximum_Length_Right > 0.0),
	Clavicle_Anterior_Posterior_Diameter_Midshaft_Left FLOAT CHECK (Clavicle_Anterior_Posterior_Diameter_Midshaft_Left > 0.0),
	Clavicle_Anterior_Posterior_Diameter_Midshaft_Right FLOAT CHECK (Clavicle_Anterior_Posterior_Diameter_Midshaft_Right > 0.0),
	Clavicle_Superior_Inferior_Diameter_Midshaft_Left FLOAT CHECK (Clavicle_Superior_Inferior_Diameter_Midshaft_Left > 0.0),
	Clavicle_Superior_Inferior_Diameter_Midshaft_Right FLOAT CHECK (Clavicle_Superior_Inferior_Diameter_Midshaft_Right > 0.0),
	Scapula_Maximum_Height_Left FLOAT CHECK (Scapula_Maximum_Height_Left > 0.0),
	Scapula_Maximum_Height_Right FLOAT CHECK (Scapula_Maximum_Height_Right > 0.0),
	Scapula_Maximum_Breadth_Left FLOAT CHECK (Scapula_Maximum_Breadth_Left > 0.0),
	Scapula_Maximum_Breadth_Right FLOAT CHECK (Scapula_Maximum_Breadth_Right > 0.0),
	Scapula_Spine_Length_Left FLOAT CHECK (Scapula_Spine_Length_Left > 0.0),
	Scapula_Spine_Length_Right FLOAT CHECK (Scapula_Spine_Length_Right > 0.0),
	Scapula_Supraspinous_Length_Left FLOAT CHECK (Scapula_Supraspinous_Length_Left > 0.0),
	Scapula_Supraspinous_Length_Right FLOAT CHECK (Scapula_Supraspinous_Length_Right > 0.0),
	Scapula_Infraspinous_Length_Left FLOAT CHECK (Scapula_Infraspinous_Length_Left > 0.0),
	Scapula_Infraspinous_Length_Right FLOAT CHECK (Scapula_Infraspinous_Length_Right > 0.0),
	Scapula_Glenoid_Cavity_Breadth_Left FLOAT CHECK (Scapula_Glenoid_Cavity_Breadth_Left > 0.0),
	Scapula_Glenoid_Cavity_Breadth_Right FLOAT CHECK (Scapula_Glenoid_Cavity_Breadth_Right > 0.0),
	Scapula_Glenoid_Cavity_Height_Left FLOAT CHECK (Scapula_Glenoid_Cavity_Height_Left > 0.0),
	Scapula_Glenoid_Cavity_Height_Right FLOAT CHECK (Scapula_Glenoid_Cavity_Height_Right > 0.0),
	Scapula_Glenoid_To_Inferior_Angle_Left FLOAT CHECK (Scapula_Glenoid_To_Inferior_Angle_Left > 0.0),
	Scapula_Glenoid_To_Inferior_Angle_Right FLOAT CHECK (Scapula_Glenoid_To_Inferior_Angle_Right > 0.0),
	Manubrium_Length FLOAT CHECK (Manubrium_Length > 0.0),
	Mesosternum_Length FLOAT CHECK (Mesosternum_Length > 0.0),
	Stenebra_1_Width FLOAT CHECK (Stenebra_1_Width > 0.0),
	Stenebra_3_Width FLOAT CHECK (Stenebra_3_Width > 0.0),
	Humerus_Maximum_Length_Left FLOAT CHECK (Humerus_Maximum_Length_Left > 0.0),
	Humerus_Maximum_Length_Right FLOAT CHECK (Humerus_Maximum_Length > 0.0),
	Humerus_Proximate_Epiphysis_Breadth_Left FLOAT CHECK (Humerus_Proximate_Epiphysis_Breadth_Left > 0.0),
	Humerus_Proximate_Epiphysis_Breadth_Right FLOAT CHECK (Humerus_Proximate_Epiphysis_Breadth_Right > 0.0),
	Humerus_Maximum_Diameter_Midshaft_Left FLOAT CHECK (Humerus_Maximum_Diameter_Midshaft_Left > 0.0),
	Humerus_Maximum_Diameter_Midshaft_Right FLOAT CHECK (Humerus_Maximum_Diameter_Midshaft_Right > 0.0),
	Humerus_Minimum_Diameter_Midshaft_Left FLOAT CHECK (Humerus_Minimum_Diameter_Midshaft_Left > 0.0),
	Humerus_Minimum_Diameter_Midshaft_Right FLOAT CHECK (Humerus_Minimum_Diameter_Midshaft_Right > 0.0),
	Humerus_Maximum_Diameter_Of_Head_Left FLOAT CHECK (Humerus_Maximum_Diameter_Of_Head_Left > 0.0),
	Humerus_Maximum_Diameter_Of_Head_Right FLOAT CHECK (Humerus_Maximum_Diameter_Of_Head_Right > 0.0),
	Humerus_Epicondylar_Breadth_Left FLOAT CHECK (Humerus_Epicondylar_Breadth_Left > 0.0),
	Humerus_Epicondylar_Breadth_Right FLOAT CHECK (Humerus_Epicondylar_Breadth_Right > 0.0),
	Humerus_Least_Circumference_Of_Shaft_Left FLOAT CHECK (Humerus_Least_Circumference_Of_Shaft_Left > 0.0),
	Humerus_Least_Circumference_Of_Shaft_Right FLOAT CHECK (Humerus_Least_Circumference_Of_Shaft_Right > 0.0),
	Radius_Maximum_Length_Left FLOAT CHECK (Radius_Maximum_Length_Left > 0.0),
	Radius_Maximum_Length_Right FLOAT CHECK (Radius_Maximum_Length_Right > 0.0),
	Radius_Maximum_Diameter_Of_Head_Left FLOAT CHECK (Radius_Maximum_Diameter_Of_Head_Left > 0.0),
	Radius_Maximum_Diameter_Of_Head_Right FLOAT CHECK (Radius_Maximum_Diameter_Of_Head_Right > 0.0),
	Radius_Anterior_Posterior_Diameter_Of_Shaft_Left FLOAT CHECK (Radius_Anterior_Posterior_Diameter_Of_Shaft_Left > 0.0),
	Radius_Anterior_Posterior_Diameter_Of_Shaft_Right FLOAT CHECK (Radius_Anterior_Posterior_Diameter_Of_Shaft_Right > 0.0),
	Radius_Medial_Lateral_Diameter_Of_Shaft_Left FLOAT CHECK (Radius_Medial_Lateral_Diameter_Of_Shaft_Left > 0.0),
	Radius_Medial_Lateral_Diameter_Of_Shaft_Right FLOAT CHECK (Radius_Medial_Lateral_Diameter_Of_Shaft_Right > 0.0),
	Radius_Neck_Shaft_Circumference_Left FLOAT CHECK (Radius_Neck_Shaft_Circumference_Left > 0.0),
	Radius_Neck_Shaft_Circumference_Right FLOAT CHECK (Radius_Neck_Shaft_Circumference_Right > 0.0),
	Ulna_Maximum_Length_Left FLOAT CHECK (Ulna_Maximum_Length_Left > 0.0),
	Ulna_Maximum_Length_Right FLOAT CHECK (Ulna_Maximum_Length_Right > 0.0),
	Ulna_Physiological_Length_Left FLOAT CHECK (Ulna_Physiological_Length_Left > 0.0),
	Ulna_Physiological_Length_Right FLOAT CHECK (Ulna_Physiological_Length_Right > 0.0),
	Ulna_Minimum_Breadth_Olecranon_Left FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Left > 0.0),
	Ulna_Minimum_Breadth_Olecranon_Right FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Right > 0.0),
	Ulna_Maximum_Breadth_Olecranon_Left FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Left > 0.0),
	Ulna_Maximum_Breadth_Olecranon_Right FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Right > 0.0),
	Ulna_Maximum_Width_Olecranon_Left FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Left > 0.0),
	Ulna_Maximum_Width_Olecranon_Right FLOAT CHECK (Ulna_Maximum_Breadth_Olecranon_Right > 0.0),
	Ulna_Olecranon_Radial_Notch_Left FLOAT CHECK (Ulna_Olecranon_Radial_Notch_Left > 0.0),
	Ulna_Olecranon_Radial_Notch_Right FLOAT CHECK (Ulna_Olecranon_Radial_Notch_Right > 0.0),
	Ulna_Olecranon_Coronial_Left FLOAT CHECK (Ulna_Olecranon_Coronial_Left > 0.0),
	Ulna_Olecranon_Coronial_Right FLOAT CHECK (Ulna_Olecranon_Coronial_Right > 0.0),
	Ulna_Anterior_Posterior_Diameter_Of_Shaft_Left FLOAT CHECK (Ulna_Anterior_Posterior_Diameter_Of_Shaft_Left > 0.0),
	Ulna_Anterior_Posterior_Diameter_Of_Shaft_Right FLOAT CHECK (Ulna_Anterior_Posterior_Diameter_Of_Shaft_Right > 0.0),
	Ulna_Medial_Lateral_Diameter_Of_Shaft_Left FLOAT CHECK (Ulna_Medial_Lateral_Diameter_Of_Shaft_Left > 0.0),
	Ulna_Medial_Lateral_Diameter_Of_Shaft_Right FLOAT CHECK (Ulna_Medial_Lateral_Diameter_Of_Shaft_Right > 0.0),
	Ulna_Least_Circumference_Of_Shaft_Left FLOAT CHECK (Ulna_Least_Circumference_Of_Shaft_Left > 0.0),
	Ulna_Least_Circumference_Of_Shaft_Right FLOAT CHECK (Ulna_Least_Circumference_Of_Shaft_Right > 0.0),
	Sacrum_Anterior_Length FLOAT CHECK (Sacrum_Anterior_Length > 0.0),
	Sacrum_Anterior_Posterior_Breadth FLOAT CHECK (Sacrum_Anterior_Posterior_Breadth > 0.0),
	Sacrum_Maximum_Breadth_S1 FLOAT CHECK (Sacrum_Maximum_Breadth_S1 > 0.0),
	Iliac_Breadth FLOAT CHECK (Iliac_Breadth > 0.0),
	
	Femur_Maximum_Length_Left FLOAT CHECK (Femur_Maximum_Length_Left > 0.0),
	Femur_Maximum_Length_Right FLOAT CHECK (Femur_Maximum_Length_Right > 0.0),
	
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);

CREATE TABLE Curation_Cranial_Measurements
(
	Donor_ID VARCHAR(10) CHECK (REGEXP_LIKE(Donor_ID , 'DO[0-9]*-[0-9]*')),
	Maximum_Length FLOAT CHECK (Maximum_Length > 0.0),
	Maximum_Breadth FLOAT CHECK (Maximum_Breadth > 0.0),
	Bizygomatic_Breadth FLOAT CHECK (Bizygomatic_Breadth > 0.0),
	Basion_To_Bregma FLOAT CHECK (Basion_To_Bregma > 0.0),
	Cranial_Base_Length FLOAT CHECK (Cranial_Base_Length > 0.0),
	Basion_To_Prosthion_Length FLOAT CHECK (Basion_To_Prosthion_Length > 0.0),
	Maximum_Alveolar_Breadth FLOAT CHECK (Maximum_Alveolar_Breadth > 0.0),
	Maximum_Alveolar_Length FLOAT CHECK (Maximum_Alveolar_Length > 0.0),
	Biauricular_Breadth FLOAT CHECK (Biauricular_Breadth > 0.0),
	Upper_Facial_Height FLOAT CHECK (Upper_Facial_Height > 0.0),
	Minimum_Frontal_Breadth FLOAT CHECK (Minimum_Frontal_Breadth > 0.0),
	Upper_Facial_Breadth FLOAT CHECK (Upper_Facial_Breadth > 0.0),
	Nasal_Height FLOAT CHECK (Nasal_Height > 0.0),
	Nasal_Breadth FLOAT CHECK (Nasal_Breadth > 0.0),
	Orbital_Breadth FLOAT CHECK (Orbital_Breadth > 0.0),
	Orbital_Height FLOAT CHECK (Orbital_Height > 0.0),
	Biorbital_Breadth FLOAT CHECK (Biorbital_Breadth > 0.0),
	Interorbital_Breadth FLOAT CHECK (Interorbital_Breadth > 0.0),
	Frontal_Chord FLOAT CHECK (Frontal_Chord > 0.0),
	Parietal_Chord FLOAT CHECK (Parietal_Chord > 0.0),
	Occipital_Chord FLOAT CHECK (Occipital_Chord > 0.0),
	Foramen_Magnum_Length FLOAT CHECK (Foramen_Magnum_Length > 0.0),
	Foramen_Magnum_Breadth FLOAT CHECK (Foramen_Magnum_Breadth > 0.0),
	Mastoid_Length FLOAT CHECK (Mastoid_Length > 0.0),
	Biasterion_Breadth FLOAT CHECK (Biasterion_Breadth > 0.0),
	Zygomaxillary_Breadth FLOAT CHECK (Zygomaxillary_Breadth > 0.0),
	Mid_Orbital_Width FLOAT CHECK (Mid_Orbital_Width > 0.0),
	--MANDIBULAR MEASUREMENTS
	
	FOREIGN KEY (Donor_ID) REFERENCES Donor(Donor_ID)
);
