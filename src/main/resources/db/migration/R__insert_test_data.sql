-- Insert test doctors
INSERT INTO aerzte (id, name, version)
VALUES ('8a7b6c5d-4e3f-2a1b-0c9d-8e7f6a5b4c3d', 'Dr. Julia Schmidt', 1),
       ('1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 'Dr. Thomas Müller', 1),
       ('3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f', 'Dr. Anna Weber', 1)
ON CONFLICT DO NOTHING;

-- Insert test patients
INSERT INTO patienten (id, titel, vorname, nachname, strasse, hausnummer, plz, stadt, tel_mobil, tel_festnetz, email,
                       geburtstag, version)
VALUES ('a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', NULL, 'Max', 'Mustermann', 'Hauptstraße', '123', '10115', 'Berlin',
        '0151-12345678', '030-87654321', 'max@example.com', '1980-05-15', 1),
       ('b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', 'Prof.', 'Maria', 'Meyer', 'Lindenallee', '45', '20144', 'Hamburg',
        '0170-98765432', NULL, 'maria.meyer@example.com', '1975-11-23', 1),
       ('c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', NULL, 'Peter', 'Schmidt', 'Kirchweg', '7', '80331', 'München',
        '0176-55443322', '089-12345678', 'peter@example.com', '1990-08-30', 1),
       ('d4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a', 'Dr.', 'Sabine', 'Wagner', 'Schillerstraße', '29', '60313', 'Frankfurt',
        '0177-11223344', NULL, 'sabine@example.com', '1968-04-12', 1)
ON CONFLICT DO NOTHING;

-- Insert test prescriptions (rezepte)
INSERT INTO rezepte (id, patient_id, ausgestellt_am, ausgestellt_von_arzt_id, preis_gesamt, rechnungsnummer, version)
VALUES ('e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', '2024-03-15',
        '8a7b6c5d-4e3f-2a1b-0c9d-8e7f6a5b4c3d', 91.74, 'R24-001', 1),
       ('f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', '2024-03-20',
        '1a2b3c4d-5e6f-7a8b-9c0d-1e2f3a4b5c6d', 144.97, 'R24-002', 1),
       ('a7b8c9d0-e1f2-3a4b-5c6d-7e8f9a0b1c2d', 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', '2024-03-25',
        '3c4d5e6f-7a8b-9c0d-1e2f-3a4b5c6d7e8f', 217.91, 'R24-003', 1),
       ('b8c9d0e1-f2a3-4b5c-6d7e-8f9a0b1c2d3e', 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a', '2024-04-01',
        '8a7b6c5d-4e3f-2a1b-0c9d-8e7f6a5b4c3d', 113.81, 'R24-004', 1)
ON CONFLICT DO NOTHING;

-- Insert prescription positions (rezept_pos)
INSERT INTO rezept_pos (id, rezept_id, index, anzahl, einzelpreis, preis_gesamt, behandlungsart_name, behandlungsart_id)
VALUES ('c9d0e1f2-a3b4-5c6d-7e8f-9a0b1c2d3e4f', 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b', 0, 3, 22.84, 68.52,
        'Klassische Massagetherapie', 'cfdc701b-c5f9-4000-8d4b-85ed7aa7a141'),
       ('d0e1f2a3-b4c5-6d7e-8f9a-0b1c2d3e4f5a', 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b', 1, 1, 37.60, 37.60,
        'Manuelle Therapie', 'f5571a9f-c679-4422-8750-5faa760e8ea7'),

       ('e1f2a3b4-c5d6-7e8f-9a0b-1c2d3e4f5a6b', 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', 0, 2, 38.00, 76.00,
        'Manuelle Lymphdrainage (30 Min.)', '2a4f9ebd-9963-4c60-a7ec-5591cbf7f3b3'),
       ('f2a3b4c5-d6e7-8f9a-0b1c-2d3e4f5a6b7c', 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', 1, 2, 31.30, 62.60,
        'Krankengymnastik', '1b102da5-b8b4-4e78-8a01-1f9c8552cdc5'),
       ('a3b4c5d6-e7f8-9a0b-1c2d-3e4f5a6b7c8d', 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', 2, 1, 17.07, 17.07,
        'Wärmepackung', '43c27a35-612b-4297-98da-2bb93c24f723'),

       ('b4c5d6e7-f8a9-0b1c-2d3e-4f5a6b7c8d9e', 'a7b8c9d0-e1f2-3a4b-5c6d-7e8f9a0b1c2d', 0, 1, 56.98, 56.98,
        'Manuelle Lymphdrainage (45 Min.)', 'e9107b42-91da-47a8-9fcc-7e1fdf69b058'),
       ('c5d6e7f8-a9b0-1c2d-3e4f-5a6b7c8d9e0f', 'a7b8c9d0-e1f2-3a4b-5c6d-7e8f9a0b1c2d', 1, 2, 58.94, 117.88,
        'Krankengymnastik am Gerät', 'c378461c-f410-4655-a62d-b2d4124ec38b'),
       ('d6e7f8a9-b0c1-2d3e-4f5a-6b7c8d9e0f1a', 'a7b8c9d0-e1f2-3a4b-5c6d-7e8f9a0b1c2d', 2, 3, 31.30, 93.90,
        'Krankengymnastik', '1b102da5-b8b4-4e78-8a01-1f9c8552cdc5'),

       ('e7f8a9b0-c1d2-3e4f-5a6b-7c8d9e0f1a2b', 'b8c9d0e1-f2a3-4b5c-6d7e-8f9a0b1c2d3e', 0, 2, 37.60, 75.20,
        'Manuelle Therapie', 'f5571a9f-c679-4422-8750-5faa760e8ea7'),
       ('f8a9b0c1-d2e3-4f5a-6b7c-8d9e0f1a2b3c', 'b8c9d0e1-f2a3-4b5c-6d7e-8f9a0b1c2d3e', 1, 1, 17.07, 17.07,
        'Wärmepackung', '43c27a35-612b-4297-98da-2bb93c24f723'),
       ('a9b0c1d2-e3f4-5a6b-7c8d-9e0f1a2b3c4d', 'b8c9d0e1-f2a3-4b5c-6d7e-8f9a0b1c2d3e', 2, 1, 22.84, 22.84,
        'Klassische Massagetherapie', 'cfdc701b-c5f9-4000-8d4b-85ed7aa7a141')
ON CONFLICT DO NOTHING;

-- Insert test behandlungen
INSERT INTO behandlungen (id, patient_id, rezept_id, start_zeit, end_zeit, version)
VALUES ('11a2b3c4-d5e6-7f8a-9b0c-1d2e3f4a5b6c', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b', '2025-07-01 09:00:00', '2025-07-01 10:00:00', 1),
       ('22b3c4d5-e6f7-8a9b-0c1d-2e3f4a5b6c7d', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', 'e5f6a7b8-c9d0-1e2f-3a4b-5c6d7e8f9a0b', '2025-07-02 14:30:00', '2025-07-02 15:30:00', 1),
       ('33c4d5e6-f7a8-9b0c-1d2e-3f4a5b6c7d8e', 'a1b2c3d4-e5f6-7a8b-9c0d-1e2f3a4b5c6d', null, '2025-07-03 11:15:00', '2025-07-03 12:15:00', 1),

       ('44d5e6f7-a8b9-0c1d-2e3f-4a5b6c7d8e9f', 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', '2024-03-25 08:00:00', '2024-03-25 09:00:00', 1),
       ('55e6f7a8-b9c0-1d2e-3f4a-5b6c7d8e9f0a', 'b2c3d4e5-f6a7-8b9c-0d1e-2f3a4b5c6d7e', 'f6a7b8c9-d0e1-2f3a-4b5c-6d7e8f9a0b1c', '2024-03-27 13:45:00', '2024-03-27 14:45:00', 1),

       ('66f7a8b9-c0d1-2e3f-4a5b-6c7d8e9f0a1b', 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', null, '2024-03-28 10:30:00', '2024-03-28 11:30:00', 1),
       ('77a8b9c0-d1e2-3f4a-5b6c-7d8e9f0a1b2c', 'c3d4e5f6-a7b8-9c0d-1e2f-3a4b5c6d7e8f', null, '2024-03-30 16:00:00', '2024-03-30 17:00:00', 1),

       ('88b9c0d1-e2f3-4a5b-6c7d-8e9f0a1b2c3d', 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a', null, '2024-04-02 12:00:00', '2024-04-02 13:00:00', 1),
       ('99c0d1e2-f3a4-5b6c-7d8e-9f0a1b2c3d4e', 'd4e5f6a7-b8c9-0d1e-2f3a-4b5c6d7e8f9a', null, '2024-04-04 15:30:00', '2024-04-04 16:30:00', 1)
ON CONFLICT DO NOTHING;