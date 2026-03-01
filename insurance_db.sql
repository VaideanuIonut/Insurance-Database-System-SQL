-- 0. CURATARE BAZA DE DATE (DROP TABLES)
DROP TABLE pr_daune CASCADE CONSTRAINTS;
DROP TABLE pr_obiecte_asigurate CASCADE CONSTRAINTS;
DROP TABLE pr_polite CASCADE CONSTRAINTS;
DROP TABLE pr_clienti CASCADE CONSTRAINTS;
DROP TABLE pr_tipuri_polita CASCADE CONSTRAINTS;
DROP TABLE pr_tipuri_clienti CASCADE CONSTRAINTS;

-- I)CREARE TABELE

-- 1. Tabela de Referinta: PR_TIPURI_CLIENTI
CREATE TABLE pr_tipuri_clienti (
    id_tip_client NUMBER(5) CONSTRAINT pk_pr_tip_client PRIMARY KEY,
    descriere_tip VARCHAR2(50) NOT NULL CONSTRAINT uq_pr_desc_tip UNIQUE,
    data_creare DATE DEFAULT SYSDATE
);

-- 2. Tabela de Referinta: PR_TIPURI_POLITA
CREATE TABLE pr_tipuri_polita (
    id_tip_polita NUMBER(5) CONSTRAINT pk_pr_tip_polita PRIMARY KEY,
    nume_tip VARCHAR2(50) NOT NULL CONSTRAINT uq_pr_nume_tip UNIQUE,
    prima_standard NUMBER(10, 2) CHECK (prima_standard > 0)
);

-- 3. Tabela Principala: PR_CLIENTI
CREATE TABLE pr_clienti (
    id_client NUMBER(10) CONSTRAINT pk_pr_clienti PRIMARY KEY,
    nume_complet VARCHAR2(100) NOT NULL,
    cui_cnp VARCHAR2(20) NOT NULL CONSTRAINT uq_pr_cui_cnp UNIQUE,
    adresa VARCHAR2(200),
    data_inscriere DATE DEFAULT SYSDATE,
    id_tip_client NUMBER(5),
    -- Legatura cu Tipuri Clienti
    CONSTRAINT fk_pr_client_tip FOREIGN KEY (id_tip_client)
    REFERENCES pr_tipuri_clienti(id_tip_client)
);

-- 4. Tabela Principala: PR_POLITE
CREATE TABLE pr_polite (
    id_polita NUMBER(10) CONSTRAINT pk_pr_polite PRIMARY KEY,
    suma_asigurata NUMBER(12, 2) NOT NULL,
    prima_platita NUMBER(10, 2) NOT NULL,
    data_emitere DATE NOT NULL,
    data_expirare DATE NOT NULL,
    status_polita VARCHAR2(20) DEFAULT 'ACTIVA',
    id_client NUMBER(10) NOT NULL,
    id_tip_polita NUMBER(5) NOT NULL,
    -- Legaturi (FK)
    CONSTRAINT fk_pr_polita_client FOREIGN KEY (id_client)
    REFERENCES pr_clienti(id_client) ON DELETE CASCADE,
    CONSTRAINT fk_pr_polita_tip FOREIGN KEY (id_tip_polita)
    REFERENCES pr_tipuri_polita(id_tip_polita),
    -- Validare: Expirarea trebuie sa fie dupa Emitere
    CONSTRAINT ck_pr_date_polita CHECK (data_expirare > data_emitere)
);

-- 5. Tabela Detaliu: PR_OBIECTE_ASIGURATE
CREATE TABLE pr_obiecte_asigurate (
    id_obiect NUMBER(10) CONSTRAINT pk_pr_obiecte PRIMARY KEY,
    descriere VARCHAR2(100),
    valoare_estimata NUMBER(12, 2),
    id_polita NUMBER(10) NOT NULL,
    -- Legatura cu Polita
    CONSTRAINT fk_pr_obiect_polita FOREIGN KEY (id_polita)
    REFERENCES pr_polite(id_polita) ON DELETE CASCADE
);

-- 6. Tabela Detaliu: PR_DAUNE
CREATE TABLE pr_daune (
    id_dauna NUMBER(10) CONSTRAINT pk_pr_daune PRIMARY KEY,
    data_eveniment DATE NOT NULL,
    descriere_dauna VARCHAR2(255),
    valoare_estimata NUMBER(12, 2),
    id_polita NUMBER(10) NOT NULL,
    -- Legatura cu Polita
    CONSTRAINT fk_pr_dauna_polita FOREIGN KEY (id_polita)
    REFERENCES pr_polite(id_polita) ON DELETE CASCADE
);

-- II)ACTUALIZARE STRUCTURA TABLES

-- Adaugam coloana EMAIL la tabelul Clienti
ALTER TABLE pr_clienti 
ADD email VARCHAR2(100);

-- Adaugam constrangere ca EMAIL-ul sa fie unic
ALTER TABLE pr_clienti
ADD CONSTRAINT uq_pr_email_client UNIQUE (email);

-- Marim spatiul pentru descrierea daunei (de la 255 la 500 caractere)
ALTER TABLE pr_daune
MODIFY descriere_dauna VARCHAR2(500);

-- Adaugam o verificare ca Suma Asigurata sa fie pozitiva
ALTER TABLE pr_polite
ADD CONSTRAINT ck_pr_suma_pozitiva CHECK (suma_asigurata > 0);

-- III)INSERARE IN TABLES ENTRY URI
-- 1. Inserare in PR_TIPURI_CLIENTI (10 inregistrari)
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (1, 'Persoana Fizica Standard');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (2, 'Persoana Fizica VIP');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (3, 'Persoana Juridica IMM');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (4, 'Corporatie Multinationala');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (5, 'Institutie Publica');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (6, 'ONG');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (7, 'Persoana Fizica Autorizata (PFA)');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (8, 'Intreprindere Individuala');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (9, 'Asociatie de Proprietari');
INSERT INTO pr_tipuri_clienti (id_tip_client, descriere_tip) VALUES (10, 'Student (Reducere)');

-- 2. Inserare in PR_TIPURI_POLITA (10 inregistrari)
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (1, 'RCA Auto', 500);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (2, 'CASCO Full', 2500);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (3, 'Locuinta PAD', 100);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (4, 'Locuinta Facultativa', 350);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (5, 'Asigurare de Viata', 1200);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (6, 'Asigurare Sanatate', 1800);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (7, 'Calatorie (Travel)', 50);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (8, 'Malpraxis Medical', 800);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (9, 'Raspundere Civila', 600);
INSERT INTO pr_tipuri_polita (id_tip_polita, nume_tip, prima_standard) VALUES (10, 'Bunuri in Tranzit', 450);

-- 3. Inserare in PR_CLIENTI (12 inregistrari)
-- Nota: Folosim TO_DATE pentru date sigure si ID-urile de tipuri de mai sus.
INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (101, 'Popescu Ion', '1900101123456', 'Str. Florilor Nr. 1, Bucuresti', TO_DATE('15-01-2023', 'DD-MM-YYYY'), 1, 'ion.popescu@yahoo.com');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (102, 'Ionescu Maria', '2920505123456', 'Bd. Unirii Nr. 10, Cluj', TO_DATE('20-02-2023', 'DD-MM-YYYY'), 2, 'maria.ionescu@gmail.com');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (103, 'SC Tech Solutions SRL', 'RO123456', 'Calea Victoriei 55, Bucuresti', TO_DATE('10-03-2023', 'DD-MM-YYYY'), 3, 'contact@techsolutions.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (104, 'Asociatia Salvati Cateii', 'RO987654', 'Str. Padurii 2, Brasov', TO_DATE('05-04-2023', 'DD-MM-YYYY'), 6, 'office@ong-catei.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (105, 'Cabinet Avocat Dinu', 'RO555666', 'Str. Justitiei 4, Timisoara', TO_DATE('12-05-2023', 'DD-MM-YYYY'), 7, 'avocat.dinu@legal.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (106, 'Georgescu Vlad', '1950808112233', 'Aleea Rozelor 5, Iasi', TO_DATE('01-06-2023', 'DD-MM-YYYY'), 10, 'vlad.student@univ.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (107, 'Mega Construct SA', 'RO112233', 'Zona Industriala Vest, Sibiu', TO_DATE('20-06-2023', 'DD-MM-YYYY'), 4, 'achizitii@megaconstruct.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (108, 'Primaria Sector 1', 'RO998877', 'Bd. Banu Manta 9, Bucuresti', TO_DATE('01-01-2022', 'DD-MM-YYYY'), 5, 'registratura@primaria1.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (109, 'Dumitrescu Ana', '2851212445566', 'Str. Lunga 100, Brasov', TO_DATE('15-07-2023', 'DD-MM-YYYY'), 1, 'ana.dumitrescu@mail.com');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (110, 'Stan Mihai', '1800101998877', 'Str. Mica 3, Constanta', TO_DATE('10-08-2023', 'DD-MM-YYYY'), 8, 'mihai.stan@pfa.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (111, 'Asoc Prop Bloc 4', 'RO334455', 'Str. Garii 2, Ploiesti', TO_DATE('05-09-2023', 'DD-MM-YYYY'), 9, 'admin@bloc4.ro');

INSERT INTO pr_clienti (id_client, nume_complet, cui_cnp, adresa, data_inscriere, id_tip_client, email) 
VALUES (112, 'Popa Elena', '2990505667788', 'Str. Principala 1, Oradea', TO_DATE('20-09-2023', 'DD-MM-YYYY'), 2, 'elena.vip@business.ro');


-- 4. Inserare in PR_POLITE (12 inregistrari)
-- Atentie: id_client trebuie sa existe mai sus (101-112)
INSERT INTO pr_polite VALUES (5001, 100000, 500, TO_DATE('01-01-2024','DD-MM-YYYY'), TO_DATE('01-01-2025','DD-MM-YYYY'), 'ACTIVA', 101, 1);
INSERT INTO pr_polite VALUES (5002, 50000, 2500, TO_DATE('10-01-2024','DD-MM-YYYY'), TO_DATE('10-01-2025','DD-MM-YYYY'), 'ACTIVA', 102, 2);
INSERT INTO pr_polite VALUES (5003, 200000, 350, TO_DATE('01-02-2024','DD-MM-YYYY'), TO_DATE('01-02-2025','DD-MM-YYYY'), 'ACTIVA', 101, 4);
INSERT INTO pr_polite VALUES (5004, 1000000, 1200, TO_DATE('15-02-2024','DD-MM-YYYY'), TO_DATE('15-02-2034','DD-MM-YYYY'), 'ACTIVA', 103, 5);
INSERT INTO pr_polite VALUES (5005, 5000, 50, TO_DATE('01-06-2024','DD-MM-YYYY'), TO_DATE('15-06-2024','DD-MM-YYYY'), 'EXPIRATA', 106, 7);
INSERT INTO pr_polite VALUES (5006, 20000, 100, TO_DATE('01-03-2024','DD-MM-YYYY'), TO_DATE('01-03-2025','DD-MM-YYYY'), 'ACTIVA', 109, 3);
INSERT INTO pr_polite VALUES (5007, 150000, 800, TO_DATE('01-01-2023','DD-MM-YYYY'), TO_DATE('01-01-2024','DD-MM-YYYY'), 'EXPIRATA', 105, 8);
INSERT INTO pr_polite VALUES (5008, 500000, 2500, TO_DATE('01-04-2024','DD-MM-YYYY'), TO_DATE('01-04-2025','DD-MM-YYYY'), 'SUSPENDATA', 107, 2);
INSERT INTO pr_polite VALUES (5009, 30000, 600, TO_DATE('10-04-2024','DD-MM-YYYY'), TO_DATE('10-04-2025','DD-MM-YYYY'), 'ACTIVA', 103, 9);
INSERT INTO pr_polite VALUES (5010, 10000, 450, TO_DATE('20-05-2024','DD-MM-YYYY'), TO_DATE('20-05-2025','DD-MM-YYYY'), 'ACTIVA', 108, 10);
INSERT INTO pr_polite VALUES (5011, 25000, 100, TO_DATE('01-01-2024','DD-MM-YYYY'), TO_DATE('01-01-2025','DD-MM-YYYY'), 'ANULATA', 110, 3);
INSERT INTO pr_polite VALUES (5012, 1000000, 1800, TO_DATE('01-06-2024','DD-MM-YYYY'), TO_DATE('01-06-2025','DD-MM-YYYY'), 'ACTIVA', 102, 6);

-- 5. Inserare in PR_OBIECTE_ASIGURATE (10 inregistrari)
-- Se leaga de id_polita (5001-5012)
INSERT INTO pr_obiecte_asigurate VALUES (1, 'Dacia Logan B-101-POP', 5000, 5001);
INSERT INTO pr_obiecte_asigurate VALUES (2, 'BMW X5 CJ-99-BOS', 45000, 5002);
INSERT INTO pr_obiecte_asigurate VALUES (3, 'Apartament 2 Camere Bucuresti', 120000, 5003);
INSERT INTO pr_obiecte_asigurate VALUES (4, 'Sediu Firma Birouri', 800000, 5004);
INSERT INTO pr_obiecte_asigurate VALUES (5, 'Bagaj Calatorie', 2000, 5005);
INSERT INTO pr_obiecte_asigurate VALUES (6, 'Casa la Tara Brasov', 60000, 5006);
INSERT INTO pr_obiecte_asigurate VALUES (7, 'Echipament Medical Cabinet', 15000, 5007);
INSERT INTO pr_obiecte_asigurate VALUES (8, 'Flota Camioane (Cap Tractor)', 150000, 5008);
INSERT INTO pr_obiecte_asigurate VALUES (9, 'Raspundere Civila Angajati', 0, 5009);
INSERT INTO pr_obiecte_asigurate VALUES (10, 'Mobilier Urban Sector 1', 50000, 5010);

-- 6. Inserare in PR_DAUNE (10 inregistrari)
-- Se leaga de id_polita
INSERT INTO pr_daune VALUES (1, TO_DATE('15-02-2024','DD-MM-YYYY'), 'Tamponare usoara bara spate', 1200, 5001);
INSERT INTO pr_daune VALUES (2, TO_DATE('20-03-2024','DD-MM-YYYY'), 'Parbriz fisurat piatra', 800, 5002);
INSERT INTO pr_daune VALUES (3, TO_DATE('01-04-2024','DD-MM-YYYY'), 'Inundatie baie vecin', 2500, 5003);
INSERT INTO pr_daune VALUES (4, TO_DATE('10-06-2024','DD-MM-YYYY'), 'Pierdere bagaj aeroport', 1500, 5005);
INSERT INTO pr_daune VALUES (5, TO_DATE('12-05-2024','DD-MM-YYYY'), 'Furt oglinzi laterale', 3000, 5002);
INSERT INTO pr_daune VALUES (6, TO_DATE('05-09-2023','DD-MM-YYYY'), 'Eroare procedura medicala', 5000, 5007);
INSERT INTO pr_daune VALUES (7, TO_DATE('01-05-2024','DD-MM-YYYY'), 'Accident usor in parcare', 900, 5008);
INSERT INTO pr_daune VALUES (8, TO_DATE('20-05-2024','DD-MM-YYYY'), 'Vandalism banca parc', 400, 5010);
INSERT INTO pr_daune VALUES (9, TO_DATE('10-06-2024','DD-MM-YYYY'), 'Consultatie urgenta', 600, 5012);
INSERT INTO pr_daune VALUES (10, TO_DATE('15-06-2024','DD-MM-YYYY'), 'Avarie totala accident', 25000, 5001);

COMMIT;

-- IIII) Exemple query-uri

--1.Afișează ID-ul poliței, numele clientului și tipul poliței pentru toate contractele active. 
SELECT p.id_polita, cl.nume_complet AS client, tp.nume_tip AS tip_polita 
FROM pr_polite p 
JOIN pr_clienti cl ON p.id_client = cl.id_client 
JOIN pr_tipuri_polita tp ON p.id_tip_polita = tp.id_tip_polita 
WHERE p.status_polita = 'ACTIVA';

--2.Afișează ID-ul polițelor care nu au înregistrat nicio daună.
SELECT p.id_polita 
FROM pr_polite p 
LEFT JOIN pr_daune d ON p.id_polita = d.id_polita 
WHERE d.id_dauna IS NULL;

--3.Calculează suma totală a daunelor înregistrate pentru fiecare poliță.
SELECT id_polita, SUM(valoare_estimata) AS total_daune 
FROM pr_daune 
GROUP BY id_polita;

--4.Afișează doar tipurile de poliță a căror Prima Standard medie este mai mare de 800 RON.
SELECT nume_tip, AVG(prima_standard) AS prima_medie 
FROM pr_tipuri_polita 
GROUP BY nume_tip 
HAVING AVG(prima_standard) > 800;

--5.Găsește polița/polițele care au cea mai mică primă plătită.
SELECT id_polita, prima_platita
FROM pr_polite 
WHERE prima_platita = (SELECT MIN(prima_platita) FROM pr_polite);

--6.Afișează ID-ul polițelor care au înregistrat daune mai mari decât orice Prima Standard din tabelul pr_tipuri_polita
SELECT id_polita 
FROM pr_daune 
WHERE valoare_estimata > ALL (SELECT prima_standard FROM pr_tipuri_polita);

--7.Afișează ID-ul clienților care nu dețin nicio poliță CASCO (Tip ID 2).
SELECT id_client 
FROM pr_clienti
MINUS
SELECT id_client FROM pr_polite WHERE id_tip_polita = 2;

--8.Clasifică polițele în 'Scurtă' (sub 366 zile) sau 'Lungă'.
SELECT id_polita, data_emitere, data_expirare, 
CASE
WHEN data_expirare - data_emitere <= 366 THEN 'Durata Scurta'
ELSE 'Durata Lunga'
END AS durata_contract
FROM pr_polite;

--9.Afișează numele clientului și ziua din săptămână (ex: 'Luni') în care s-a înscris. (Funcție Dată)
SELECT nume_complet, TO_CHAR(data_inscriere, 'DY') AS Ziua_Inscrierii 
FROM pr_clienti;

--10.Afișează Prima Standard rotunjită la cel mai apropiat număr întreg. (Funcție Numerică)
SELECT nume_tip, prima_standard, ROUND(prima_standard) AS prima_rotunjita 
FROM pr_tipuri_polita;




