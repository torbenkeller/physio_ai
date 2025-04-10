INSERT INTO behandlungsarten (id, name, preis)
VALUES ('cfdc701b-c5f9-4000-8d4b-85ed7aa7a141', 'Klassische Massagetherapie', 22.84),
       ('2a4f9ebd-9963-4c60-a7ec-5591cbf7f3b3', 'Manuelle Lymphdrainage (30 Min.)', 38),
       ('e9107b42-91da-47a8-9fcc-7e1fdf69b058', 'Manuelle Lymphdrainage (45 Min.)', 56.98),
       ('398df86a-51ef-4f12-8fbc-40377230dcbc', 'Manuelle Lymphdrainage (60 Min.)', 75.99),
       ('1b102da5-b8b4-4e78-8a01-1f9c8552cdc5', 'Krankengymnastik', 31.3),
       ('adf3630e-7706-4aca-b030-5326f164c959', 'Krankengymnastik Doppelbehandlung', 62.6),
       ('c378461c-f410-4655-a62d-b2d4124ec38b', 'Krankengymnastik am Gerät', 58.94),
       ('a5422b49-88b0-4e52-915e-f159261c711f', 'Krankengymnastik ZNS', 49.71),
       ('65cbab03-f884-4a2a-a510-0fba056224e9', 'Krankengymnastik ZNS Doppelbehandlung', 99.42),
       ('f5571a9f-c679-4422-8750-5faa760e8ea7', 'Manuelle Therapie', 37.6),
       ('e48f0626-6ecd-4d26-8909-bd1e41508e2e', 'Manuelle Therapie Doppelbehandlung', 75.2),
       ('43c27a35-612b-4297-98da-2bb93c24f723', 'Wärmepackung', 17.07),
       ('e70d961c-80fa-461d-9ecd-17852cc052d0', 'Atlastherapie', 290)
ON CONFLICT DO NOTHING;
